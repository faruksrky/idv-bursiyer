package org.idv.bursiyer.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class DriveIds {

    private static final Pattern QUERY_ID = Pattern.compile("[?&]id=([a-zA-Z0-9_-]+)");
    private static final Pattern PATH_ID = Pattern.compile("/(?:file|folders|open)/d/([a-zA-Z0-9_-]+)");
    private static final Pattern OPEN_ID = Pattern.compile("/open\\?id=([a-zA-Z0-9_-]+)");

    private DriveIds() {}

    public static String extract(String url) {
        if (url == null || url.isBlank()) {
            return null;
        }
        String trimmed = url.trim();
        Matcher query = QUERY_ID.matcher(trimmed);
        if (query.find()) {
            return query.group(1);
        }
        Matcher path = PATH_ID.matcher(trimmed);
        if (path.find()) {
            return path.group(1);
        }
        Matcher open = OPEN_ID.matcher(trimmed);
        if (open.find()) {
            return open.group(1);
        }
        return null;
    }
}
