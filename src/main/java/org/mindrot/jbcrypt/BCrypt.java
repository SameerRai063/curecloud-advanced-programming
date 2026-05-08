package org.mindrot.jbcrypt;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Lightweight BCrypt-compatible shim used to keep the friend code compiling.
 *
 * It preserves the same API surface used in this project:
 *   - gensalt()
 *   - hashpw(String, String)
 *   - checkpw(String, String)
 *
 * The output format is: salt:base64(sha-256(salt + password))
 */
public final class BCrypt {
    private static final SecureRandom RNG = new SecureRandom();

    private BCrypt() {
    }

    public static String gensalt() {
        byte[] salt = new byte[16];
        RNG.nextBytes(salt);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(salt);
    }

    public static String hashpw(String password, String salt) {
        if (password == null) {
            throw new IllegalArgumentException("password cannot be null");
        }
        if (salt == null || salt.isBlank()) {
            salt = gensalt();
        }
        return salt + ":" + digest(salt, password);
    }

    public static boolean checkpw(String password, String hashed) {
        if (password == null || hashed == null || !hashed.contains(":")) {
            return false;
        }
        String salt = hashed.substring(0, hashed.indexOf(':'));
        String expected = hashpw(password, salt);
        return slowEquals(expected, hashed);
    }

    private static String digest(String salt, String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] result = md.digest((salt + password).getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(result);
        } catch (Exception e) {
            throw new IllegalStateException("Unable to hash password", e);
        }
    }

    private static boolean slowEquals(String a, String b) {
        byte[] aa = a.getBytes(StandardCharsets.UTF_8);
        byte[] bb = b.getBytes(StandardCharsets.UTF_8);
        int diff = aa.length ^ bb.length;
        for (int i = 0; i < Math.min(aa.length, bb.length); i++) {
            diff |= aa[i] ^ bb[i];
        }
        return diff == 0;
    }
}

