package org.idv.bursiyer.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PersonGendersTest {

    @Test
    void previouslyUnknownAccountingNamesResolve() {
        assertEquals(PersonGenders.ERKEK, PersonGenders.fromName("Vedat"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Hiranur Hafsa"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Süveybe"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Suveybe"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Zaına I. F."));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Zaina"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Zainab"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("ZAİNA"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("ZAINA"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Hayrünnisa"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Hayrunnisa"));
        assertEquals(PersonGenders.KIZ, PersonGenders.fromName("Zeynep Yaren"));
        assertEquals(PersonGenders.ERKEK, PersonGenders.fromName("Mustafa Ekren"));
    }

    @Test
    void splitFullNamesMatchAccountingRows() {
        assertEquals(PersonGenders.ERKEK, genderOf("Vedat Dartan"));
        assertEquals(PersonGenders.KIZ, genderOf("Hiranur Hafsa Ünal"));
        assertEquals(PersonGenders.KIZ, genderOf("Süveybe Yeşilyurt"));
        assertEquals(PersonGenders.KIZ, genderOf("Zaına I. F. Alkhazendar"));
    }

    @Test
    void unknownGenderHasNoLabel() {
        assertEquals("", PersonGenders.label(null));
        assertEquals("Kız", PersonGenders.label(PersonGenders.KIZ));
        assertEquals("Erkek", PersonGenders.label(PersonGenders.ERKEK));
    }

    private static String genderOf(String fullName) {
        return PersonGenders.fromName(PersonNames.splitFullName(fullName)[0]);
    }
}
