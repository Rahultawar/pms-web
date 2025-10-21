package com.inventory.utils;

import java.math.BigDecimal;

public class BigDecimalUtil {
    private BigDecimalUtil() {
    }

    // PARSE BIG DECIMAL
    public static BigDecimal parseBigDecimal(String s) {
        if (s == null)
            return null;
        s = s.trim();
        if (s.isEmpty())
            return null;

        s = s.replace("\u00A0", "").replace(",", "").replace(" ", "");

        boolean negative = false;
        if (s.startsWith("(") && s.endsWith(")")) {
            negative = true;
            s = s.substring(1, s.length() - 1).trim();
        }

        try {
            BigDecimal bd = new BigDecimal(s);
            return negative ? bd.negate() : bd;
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Invalid decimal value: " + s, ex);
        }
    }
}
