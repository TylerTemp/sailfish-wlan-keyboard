#ifndef HTTP_SERVER_H
#define HTTP_SERVER_H

#include <qhttpserver/qhttpserverfwd.h>

#include <QObject>

#endif // HTTP_SERVER_H

class http_server : public QObject
{
    Q_OBJECT

public:
    explicit http_server(QObject *parent = 0);

    virtual ~ http_server();

    Q_INVOKABLE void startServer(qint16 port);

    Q_INVOKABLE void stopServer();

    Q_INVOKABLE bool isRunning() const;

    void setStaticContent(const QString & filePath);

    qint16 getPort() const;

    Q_INVOKABLE QString getIp() const;

private slots:
    void handleRequest(QHttpRequest *req, QHttpResponse *resp);

private:
    QHttpServer *server;
    QString *filePath;
    qint16 port;
    bool running;
};