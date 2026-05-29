package io.github.nejucomo.mcmania;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class McManiaPluginTest {
    @Test
    void usesExpectedNopeMessage() {
        assertEquals("nope!", McManiaPlugin.NOPE_MESSAGE);
    }
}
