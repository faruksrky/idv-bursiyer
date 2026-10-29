package org.idv.bursiyer.service;

import org.idv.bursiyer.config.KeycloakProperties;
import org.idv.bursiyer.web.dto.TokenResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import org.springframework.web.server.ResponseStatusException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class KeycloakAuthService {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private final KeycloakProperties keycloakProperties;
    private final RestClient restClient;

    public KeycloakAuthService(KeycloakProperties keycloakProperties) {
        this.keycloakProperties = keycloakProperties;
        this.restClient = RestClient.create();
    }

    public TokenResponse login(String username, String password) {
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "password");
        body.add("client_id", keycloakProperties.clientId());
        body.add("username", username);
        body.add("password", password);

        String tokenUrl = "%s/realms/%s/protocol/openid-connect/token".formatted(
                trimTrailingSlash(keycloakProperties.serverUrl()),
                keycloakProperties.realm()
        );

        try {
            return restClient.post()
                    .uri(tokenUrl)
                    .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                    .body(body)
                    .retrieve()
                    .body(TokenResponse.class);
        } catch (HttpClientErrorException.Unauthorized | HttpClientErrorException.BadRequest e) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, mapKeycloakError(e));
        } catch (HttpClientErrorException e) {
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY, "Kimlik doğrulama servisine ulaşılamadı");
        }
    }

    private String mapKeycloakError(HttpClientErrorException e) {
        try {
            JsonNode node = OBJECT_MAPPER.readTree(e.getResponseBodyAsString());
            String description = node.path("error_description").asText("");
            if ("Invalid user credentials".equals(description)) {
                return "Kullanıcı adı veya şifre hatalı.";
            }
            if (!description.isBlank()) {
                return description;
            }
        } catch (Exception ignored) {
            // fall through
        }
        return "Giriş bilgileri hatalı. Lütfen tekrar deneyin.";
    }

    private static String trimTrailingSlash(String url) {
        return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }
}
