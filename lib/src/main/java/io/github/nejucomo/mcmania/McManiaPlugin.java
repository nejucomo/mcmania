package io.github.nejucomo.mcmania;

import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.block.BlockBreakEvent;
import org.bukkit.plugin.java.JavaPlugin;

public final class McManiaPlugin extends JavaPlugin implements Listener {
    static final String NOPE_MESSAGE = "nope!";

    @Override
    public void onEnable() {
        getServer().getPluginManager().registerEvents(this, this);
    }

    @EventHandler
    public void onBlockBreak(BlockBreakEvent event) {
        event.setCancelled(true);
        event.getPlayer().sendMessage(NOPE_MESSAGE);
    }
}
