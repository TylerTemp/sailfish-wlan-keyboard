#include "utils.h"

Utils::Utils(QObject *parent) :QObject(parent)
{
    QGuiApplication * app = (QGuiApplication*) parent;
    this->m_clipboard = app->clipboard();
}

QString Utils::getIpAddress()
{
    QList<QString> ignores;
    ignores << "127.0.0.1";
    ignores << "::1";

    QList<QHostAddress> addrs = QNetworkInterface::allAddresses();
    QString foundIp = "localhost";

    for(int i = 0; i < addrs.count(); i ++) {
        QString ip = addrs[i].toString();
        if(ignores.contains(ip))
            continue;
        foundIp = ip;
        break;
    }
    return foundIp;
}

QList<QHostAddress> Utils::getAvailableIpAddresses()
{
    QList<QHostAddress> resultAddrs;
    QList<QHostAddress> addrs = QNetworkInterface::allAddresses();
    QString ignore("::1");

    for(int i = 0; i < addrs.count(); i ++) {
        QHostAddress addr = addrs[i];
        if(ignore != addr.toString())
            resultAddrs << addr;
    }
    return resultAddrs;
}

void Utils::setClipboard(QString content)
{
    m_clipboard->setText(content);
}

QClipboard * Utils::getClipboard()
{
    return this->m_clipboard;
}

