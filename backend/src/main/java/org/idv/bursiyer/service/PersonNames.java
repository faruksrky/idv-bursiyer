package org.idv.bursiyer.service;

import org.idv.bursiyer.domain.Scholar;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

public final class PersonNames {

    private static final Locale TR = Locale.forLanguageTag("tr-TR");

    private PersonNames() {
    }

    public static String fold(String value) {
        if (value == null) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        for (char character : value.trim().toLowerCase(TR).toCharArray()) {
            builder.append(switch (character) {
                case 'ı', 'i', 'î' -> 'i';
                case 'ğ' -> 'g';
                case 'ü', 'û' -> 'u';
                case 'ş' -> 's';
                case 'ö' -> 'o';
                case 'ç' -> 'c';
                case 'â' -> 'a';
                default -> character;
            });
        }
        return builder.toString().replaceAll("[^a-z0-9]+", " ").replaceAll("\\s+", " ").trim();
    }

    public static String titleCase(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim().replaceAll("\\s+", " ");
        if (trimmed.isBlank()) {
            return trimmed;
        }
        StringBuilder output = new StringBuilder();
        for (String token : trimmed.split(" ", -1)) {
            if (output.length() > 0) {
                output.append(' ');
            }
            output.append(titleCaseToken(token));
        }
        return output.toString();
    }

    public static String fullName(Scholar scholar) {
        return (nullToEmpty(scholar.getFirstName()) + " " + nullToEmpty(scholar.getLastName())).trim();
    }

    public static String[] splitFullName(String fullName) {
        String trimmed = titleCase(fullName == null ? "" : fullName);
        if (trimmed == null || trimmed.isBlank()) {
            return new String[] { "", "-" };
        }
        int space = trimmed.lastIndexOf(' ');
        if (space <= 0) {
            return new String[] { trimmed, "-" };
        }
        return new String[] { trimmed.substring(0, space), trimmed.substring(space + 1) };
    }

    private static String titleCaseToken(String token) {
        if (token.isEmpty()) {
            return token;
        }
        if (token.contains("-")) {
            String[] parts = token.split("-", -1);
            StringBuilder joined = new StringBuilder();
            for (int i = 0; i < parts.length; i++) {
                if (i > 0) {
                    joined.append('-');
                }
                joined.append(titleCaseToken(parts[i]));
            }
            return joined.toString();
        }
        String lower = token.toLowerCase(TR);
        int firstEnd = lower.offsetByCodePoints(0, 1);
        return lower.substring(0, firstEnd).toUpperCase(TR) + lower.substring(firstEnd);
    }

    public static Optional<Scholar> findByName(List<Scholar> scholars, String fullName) {
        String needle = fold(fullName);
        if (needle.isBlank()) {
            return Optional.empty();
        }
        List<Scholar> exact = new ArrayList<>();
        for (Scholar scholar : scholars) {
            if (fold(fullName(scholar)).equals(needle)) {
                exact.add(scholar);
            }
        }
        if (exact.size() == 1) {
            return Optional.of(exact.get(0));
        }
        if (exact.size() > 1) {
            return Optional.empty();
        }

        List<Scholar> closeLastName = new ArrayList<>();
        String needleGiven = givenName(needle);
        String needleLast = lastName(needle);
        if (!needleGiven.isBlank() && needleLast.length() >= 4) {
            for (Scholar scholar : scholars) {
                String hay = fold(fullName(scholar));
                if (givenName(hay).equals(needleGiven) && levenshtein(needleLast, lastName(hay)) <= 2) {
                    closeLastName.add(scholar);
                }
            }
            if (closeLastName.size() == 1) {
                return Optional.of(closeLastName.get(0));
            }
        }

        Scholar best = null;
        double bestScore = 0;
        int ties = 0;
        for (Scholar scholar : scholars) {
            double score = similarity(needle, fold(fullName(scholar)));
            if (score > bestScore) {
                bestScore = score;
                best = scholar;
                ties = 1;
            } else if (score == bestScore) {
                ties++;
            }
        }
        if (best != null && bestScore >= 0.92 && ties == 1) {
            return Optional.of(best);
        }
        return Optional.empty();
    }

    private static String givenName(String foldedFullName) {
        int space = foldedFullName.lastIndexOf(' ');
        return space <= 0 ? "" : foldedFullName.substring(0, space);
    }

    private static String lastName(String foldedFullName) {
        int space = foldedFullName.lastIndexOf(' ');
        return space < 0 ? foldedFullName : foldedFullName.substring(space + 1);
    }

    static double similarity(String left, String right) {
        if (left.equals(right)) {
            return 1;
        }
        int max = Math.max(left.length(), right.length());
        if (max == 0) {
            return 1;
        }
        return 1.0 - (levenshtein(left, right) / (double) max);
    }

    private static int levenshtein(String left, String right) {
        int[] previous = new int[right.length() + 1];
        int[] current = new int[right.length() + 1];
        for (int j = 0; j <= right.length(); j++) {
            previous[j] = j;
        }
        for (int i = 1; i <= left.length(); i++) {
            current[0] = i;
            for (int j = 1; j <= right.length(); j++) {
                int cost = left.charAt(i - 1) == right.charAt(j - 1) ? 0 : 1;
                current[j] = Math.min(Math.min(current[j - 1] + 1, previous[j] + 1), previous[j - 1] + cost);
            }
            int[] swap = previous;
            previous = current;
            current = swap;
        }
        return previous[right.length()];
    }

    private static String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
