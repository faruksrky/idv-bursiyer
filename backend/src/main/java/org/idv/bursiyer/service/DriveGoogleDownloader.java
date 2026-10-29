package org.idv.bursiyer.service;

import org.springframework.stereotype.Component;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class DriveGoogleDownloader {

    private static final int MAX_BYTES = 15 * 1024 * 1024;
    private static final Pattern CONFIRM = Pattern.compile("confirm=([0-9A-Za-z_-]+)");
    private static final Pattern UUID = Pattern.compile("name=\"uuid\"\\s+value=\"([^\"]+)\"");

    private final HttpClient httpClient = HttpClient.newBuilder()
            .followRedirects(HttpClient.Redirect.NORMAL)
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    public byte[] download(String driveId) throws IOException, InterruptedException {
        String firstUrl = "https://drive.google.com/uc?export=download&id=" + driveId + "&confirm=t";
        HttpResponse<byte[]> first = get(firstUrl);
        byte[] body = first.body();
        if (body != null && body.length > 0 && !DriveCacheService.looksLikeHtml(body)) {
            return requireSize(body);
        }
        String html = body == null ? "" : new String(body);
        String confirm = firstGroup(CONFIRM, html);
        String uuid = firstGroup(UUID, html);
        StringBuilder retry = new StringBuilder("https://drive.google.com/uc?export=download&id=").append(driveId);
        if (confirm != null) {
            retry.append("&confirm=").append(confirm);
        } else {
            retry.append("&confirm=t");
        }
        if (uuid != null) {
            retry.append("&uuid=").append(uuid);
        }
        HttpResponse<byte[]> second = get(retry.toString());
        byte[] retryBody = second.body();
        if (retryBody == null || retryBody.length == 0 || DriveCacheService.looksLikeHtml(retryBody)) {
            throw new IOException("Drive dosyası indirilemedi (giriş veya paylaşım gerekli)");
        }
        return requireSize(retryBody);
    }

    private HttpResponse<byte[]> get(String url) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder(URI.create(url))
                .timeout(Duration.ofSeconds(45))
                .header("User-Agent", "Mozilla/5.0 IDV-Bursiyer-Ingest")
                .GET()
                .build();
        return httpClient.send(request, HttpResponse.BodyHandlers.ofByteArray());
    }

    private static byte[] requireSize(byte[] body) throws IOException {
        if (body.length > MAX_BYTES) {
            throw new IOException("Dosya 15 MB sınırını aşıyor");
        }
        return body;
    }

    private static String firstGroup(Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text);
        return matcher.find() ? matcher.group(1) : null;
    }
}
