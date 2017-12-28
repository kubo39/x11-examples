import std.conv : to;
import x11.X;
import x11.Xlib;

void main()
{
    // Open display connection.
    auto display = XOpenDisplay(null);
    assert(display !is null, "XOpenDisplay failed.");
    scope (exit) XCloseDisplay(display);

    // Create window.
    auto screen = XDefaultScreen(display);
    auto root  =XRootWindow(display, screen);
    scope (exit) XDestroyWindow(display, root);

    XSetWindowAttributes attributes = void;
    attributes.background_pixel = XWhitePixel(display, screen);

    auto window = XCreateWindow(display, root,
                                0, 0, 400, 300,
                                0, 0,
                                InputOutput, null,
                                CWBackPixel, &attributes);

    // Set window title.
    auto title = cast(char*) "Hello-world\0".ptr;
    XStoreName(display, window, title);

    // Hook close request.
    auto wmProtocol = "WM_PROTOCOL\0".ptr;
    auto wmDeleteWindowStr = "WM_DELETE_WINDOW\0".ptr;

    auto wmProtocols = XInternAtom(display, wmProtocol, False);
    auto wmDeleteWindow = XInternAtom(display, wmDeleteWindowStr, False);

    auto protocols = [wmDeleteWindow];
    XSetWMProtocols(display, window, protocols.ptr, protocols.length.to!int);

    // Show window.
    XMapWindow(display, window);
    scope (exit) XUnmapWindow(display, root);

    // Mainloop.
    XEvent event = void;

    bool running = true;
    while (running)
    {
        XNextEvent(display, &event);

        switch (event.type)
        {
        case ClientMessage:
            if (cast(Atom) event.xclient.data.l[0] == wmDeleteWindow)
                running = false;
            break;
        default:
            // nop
        }
    }
}
