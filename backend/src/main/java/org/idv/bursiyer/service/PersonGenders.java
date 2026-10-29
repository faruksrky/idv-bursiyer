package org.idv.bursiyer.service;

import java.util.Locale;
import java.util.Set;

public final class PersonGenders {

    public static final String KIZ = "KIZ";
    public static final String ERKEK = "ERKEK";

    private static final Locale TR = Locale.forLanguageTag("tr");

    private static final Set<String> FEMALE = Set.of(
            "adile", "asya", "aylin", "ayse", "ayşe", "ayşegül", "ayşenur", "azra",
            "gulfidan", "gülfidan", "hayru", "kiymet", "kıymet", "seymanur", "şeymanur",
            "banu", "basak", "başak", "berra", "betul", "betül", "beyza", "binnaz", "busra", "büşra",
            "ceren", "cevriye", "defne", "dilek", "dilara", "dilan", "doğa", "duru",
            "ece", "elif", "elife", "emine", "esma", "esra", "eylem", "fatma", "fatıma", "feride",
            "firdevs", "fulya", "gamze", "gizem", "gül", "gülsüm", "gülşen", "hacer", "hadice",
            "halime", "hatice", "havva", "hazal", "hilal", "hulya", "hülya", "ikra", "ikraa",
            "irem", "işıl", "kübra", "kubra", "leyla", "melek", "melike", "melisa", "melis",
            "meryem", "mine", "nisa", "nihal", "nil", "nursel", "nursena", "nursima",
            "özge", "öznur", "rabia", "raziye", "rukiye", "rumeysa", "rümeysa", "sare", "seda",
            "sena", "seren", "sevgi", "seyma", "şeyma", "sidika", "sıla", "simge", "su", "sude",
            "sumeyra", "sümeyra", "sumeyye", "sümeyye", "şule", "tuğba", "tugba", "tuba", "tuana",
            "ümmü", "ümran", "yasemin", "yeşim", "yıldız", "zehra", "zeynep", "zeliha",
            "aşkın", "canan", "damla", "derya", "duygu", "ebru", "elifnaz", "elnur",
            "esmanur", "fadime", "gülcan", "gülbahar", "hanife", "hasibe", "hayriye",
            "hayrünnisa", "hayrunnisa", "hüner",
            "ilknur", "kader", "kamer", "lale", "medine", "mehtap", "merve", "mısra", "mualla",
            "naile", "naz", "nazlı", "nazli", "necla", "neşe", "nermin", "neslihan",
            "nur", "nuran", "nurgül", "nurhayat", "nuriye", "özlem", "perihan", "pınar", "pinar",
            "safiye", "saide", "selma", "semra", "sevil", "sevda", "sevim", "songül", "süheyla",
            "süveybe", "suveybe", "şerife", "şeyda", "tülay", "ulku", "ülkü", "vildan", "yagmur", "yağmur",
            "zahide", "zaına", "zaina", "zaınab", "zainab", "zümra", "hiranur", "ikrahazal", "tugbanaz", "yaren"
    );

    private static final Set<String> MALE = Set.of(
            "abdulaziz", "abdulkadir", "abdullah", "abdulnasir", "abdurrahman", "abdurrahim", "adil",
            "affan", "ahmed", "ahmet", "ali", "alper", "arif", "asım", "atakan", "ayhan", "aziz",
            "baran", "barış", "baris", "bekir", "berat", "bilal", "burak", "can", "cem", "cengiz",
            "cihan", "cüneyt", "çetin", "doğan", "ebubekir", "emir", "emre", "enes", "erdem", "eren",
            "erhan", "fatih", "ferhat", "furkan", "halil", "hamza", "harun", "hasan", "hayri", "hikmet",
            "hüseyin", "huseyin", "ibrahim", "idris", "ihsan", "ilhan", "ilyas", "isa", "ismail",
            "kadir", "kaan", "kamil", "kemal", "kerem", "koray", "mahmut", "mehmet", "mert", "metin",
            "muhammed", "muhammad", "muhammet", "muhsin", "murat", "musa", "mustafa", "mücahit",
            "necmettin", "numan", "nuri", "oğuz", "oguz", "onur", "orhan", "osman", "ömer", "omer",
            "özkan", "ozkan", "ramazan", "rasim", "recep", "ridvan", "rıdvan", "saadettin", "saban",
            "şaban", "sabri", "safa", "said", "salih", "samet", "selim", "serkan", "sefa", "sinan",
            "suat", "süleyman", "suleyman", "taha", "talha", "tarık", "tayyip", "ugur", "uğur", "umit",
            "ümit", "vedat", "volkan", "yahya", "yakup", "yasir", "yavuz", "yasin", "yunus", "yusuf", "zafer",
            "zahid", "zeki", "ziya", "ömerfaruk", "alierdem", "mehmetali", "mustafaali", "recepali",
            "hüseyinbilal", "arifömer", "tahanuman", "yusufsefa", "muhsinyasir"
    );

    private PersonGenders() {
    }

    public static String fromName(String firstName) {
        if (firstName == null || firstName.isBlank()) {
            return null;
        }
        String[] tokens = firstName.trim().toLowerCase(TR).split("[\\s./-]+");
        String compact = String.join("", tokens);
        String fromCompact = lookup(compact);
        if (fromCompact != null) {
            return fromCompact;
        }
        for (String token : tokens) {
            String gender = lookup(token);
            if (gender != null) {
                return gender;
            }
        }
        return null;
    }

    private static String lookup(String token) {
        if (token == null || token.length() < 2) {
            return null;
        }
        boolean female = FEMALE.contains(token);
        boolean male = MALE.contains(token);
        if (female && !male) {
            return KIZ;
        }
        if (male && !female) {
            return ERKEK;
        }
        return null;
    }

    public static String label(String gender) {
        if (KIZ.equals(gender)) {
            return "Kız";
        }
        if (ERKEK.equals(gender)) {
            return "Erkek";
        }
        return "";
    }
}
