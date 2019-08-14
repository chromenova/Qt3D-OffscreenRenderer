import QtQuick 2.12
import Qt3D.Core 2.12
import Qt3D.Render 2.12
import Qt3D.Input 2.12
import Qt3D.Extras 2.12
import QtQuick.Window 2.12
import QtWayland.Compositor 1.13
import QtQuick.Scene3D 2.12

import Preferences 1.0
import PhysicalKeyboardAdapter 1.0

import Vulkan 1.0
import OpenXR 1.0
import OpenXRGraphics 1.0
import Qt3D.Offscreen 1.0

WaylandCompositor {
    id:waylandCompositor
    useHardwareIntegrationExtension: false

    // The output defines the screen.
    WaylandOutput {
        sizeFollowsWindow: true
//        window: Window {
//            id: displaySurface
//            width: 1600
//            height: 900
//            visible: true

//            data: [waylandContent]
//        }
    }

    Component.onCompleted: {
        OpenXR.vulkan = Vulkan;
        Vulkan.openxr = OpenXR;
        OpenXR.initialize();

        OpenXRGraphics.leftEye = sceneRoot.leftEye;
        OpenXRGraphics.rightEye = sceneRoot.rightEye;
        OpenXRGraphics.openxr = OpenXR;
        OpenXRGraphics.initialize();

        Offscreen.sceneRoot = sceneRoot;
        Offscreen.leftEye = sceneRoot.leftEye;
        Offscreen.rightEye = sceneRoot.rightEye;

        Offscreen.graphics = OpenXRGraphics;
        Offscreen.clearFlagsColor = Qt.rgba(0, 0.5, 1, 1);
        Offscreen.initialize();
    }

    SceneRoot {
        id:sceneRoot
    }

    WlShell {
        onWlShellSurfaceCreated:
            shellSurfaces.append({shellSurface: shellSurface});
    }
    IviApplication {
        onIviSurfaceCreated:
            shellSurfaces.append({shellSurface: iviSurface});
    }
    XdgShellV6 {
        onToplevelCreated:
            shellSurfaces.append({shellSurface: xdgSurface});
    }
    XdgShell {
        onToplevelCreated:
            shellSurfaces.append({shellSurface: xdgSurface});
    }
    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    ListModel { id: shellSurfaces }

    Preferences {
        id:appPrefs
        fileName: "app_prefs.json"
    }

    Preferences {
        id:compositorPrefs
        fileName: "compositor_prefs.json"
    }
}
