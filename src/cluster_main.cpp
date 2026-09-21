#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("GSOI Cluster");
    app.setOrganizationName("GSOI");

    // app_id Wayland: Weston (kiosk-shell) lo usa per piazzare il quadro sulla
    // 2a uscita HDMI (dietro al volante). Vedi weston.ini in meta-gsoi.
    app.setDesktopFileName("org.gsoi.cluster");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("GsoiCluster", "ClusterMain");

    return app.exec();
}
