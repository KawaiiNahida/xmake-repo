package("cairo")

    set_homepage("https://cairographics.org/")
    set_description("Vector graphics library with cross-device output support.")

    set_urls("https://cairographics.org/releases/cairo-$(version).tar.xz")
    add_versions("1.16.0", "5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331")
 
    if not is_plat("windows") then
        add_deps("pkg-config", "fontconfig", "freetype", "libpng", "pixman")
    end

    if is_plat("macosx") then
        add_frameworks("CoreGraphics", "CoreFoundation", "Foundation")
    else
        add_syslinks("pthread")
    end

    on_install("macosx", "linux", function (package)
        local configs = {"--disable-dependency-tracking", "--enable-shared=no"}
        table.insert(configs, "--enable-gobject=no")
        table.insert(configs, "--enable-svg=yes")
        table.insert(configs, "--enable-tee=yes")
        table.insert(configs, "--enable-quartz=no")
        table.insert(configs, "--enable-xlib=" .. (is_plat("macosx") and "no" or "yes"))
        table.insert(configs, "--enable-xlib-xrender=" .. (is_plat("macosx") and "no" or "yes"))
        import("package.tools.autoconf").install(package, configs) 
    end)

    on_test(function (package)
        assert(package:has_cfuncs("cairo_create", {includes = "cairo/cairo.h"}))
    end)
