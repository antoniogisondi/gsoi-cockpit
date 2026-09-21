#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("GSOI Cockpit");
    app.setOrganizationName("GSOI");

    // app_id Wayland: Weston (kiosk-shell) lo usa per piazzare il cockpit sullo
    // schermo centrale (vedi weston.ini in meta-gsoi). Il quadro strumenti gira
    // in un processo separato (gsoi-cluster) con app_id org.gsoi.cluster.
    app.setDesktopFileName("org.gsoi.cockpit");

    // Registra il font icone Phosphor (famiglia "Phosphor").
    QFontDatabase::addApplicationFont(":/qt/qml/GsoiCockpit/Phosphor.ttf");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("GsoiCockpit", "Main");

    return app.exec();
}
