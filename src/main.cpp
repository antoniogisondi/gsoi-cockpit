#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("GSOI Cockpit");
    app.setOrganizationName("GSOI");

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
