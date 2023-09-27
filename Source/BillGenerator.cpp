#include "Include/BillGenerator.h"

BillGenerator::BillGenerator(QObject *parent) : QObject{parent} {
    // Fetch const values
    if(shopName.isEmpty()) {
        QSqlQuery query;
        query.exec(QString("SELECT * FROM constvalues"));
        QList<QString> constList;
        while (query.next()) {
            constList.append(query.value(0).toString());
        }
        shopName = constList.at(0);
        passWifi = constList.at(1);
        address = constList.at(2);
        phoneNum = constList.at(3);
    }

}

QString BillGenerator::shopName;
QString BillGenerator::passWifi;
QString BillGenerator::address;
QString BillGenerator::phoneNum;


void BillGenerator::collectItemInfo(int id, QString name, int total, int quantity, const QString &extraJson, bool isSizeL)
{
    ItemModel item;
    item.id = id;
    item.name = name;
    item.total = total;
    item.quantity = quantity;
    item.isSizeL = isSizeL;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(extraJson.toUtf8());
    QVariantMap extra = jsonDoc.toVariant().toMap();
    if(!extra.isEmpty()) {
        for(auto topping = extra.constBegin(); topping != extra.constEnd(); topping++) {
            QString tpName = topping.key();
            int tpCost = topping.value().toInt();
            item.toppings.insert(tpName, tpCost);
        }
    }
    listItem.append(item);
}

void BillGenerator::collectOtherInfo(QString date, QString account, QString gTotal, QString cash)
{
    this->otherInfo.append(generateRcptId());
    this->otherInfo.append(date);
    this->otherInfo.append(account);
    this->otherInfo.append(gTotal);
    this->otherInfo.append(cash);
}

void BillGenerator::clearListItem()
{
    this->listItem.clear();
    this->otherInfo.clear();
}


void BillGenerator::printBill()
{
    // Create a QTextDocument for text rendering
    QTextDocument doc;
    doc.setDefaultFont(QFont("Courier new", 8));
    QTextCursor cursor(&doc);


    QTextTableFormat tableFormat;
    tableFormat.setWidth(100);
    tableFormat.setAlignment(Qt::AlignCenter);
    tableFormat.setCellPadding(0);
    tableFormat.setCellSpacing(0);
    tableFormat.setBorder(0);

    QTextCharFormat formatForItem;
    formatForItem.setVerticalAlignment(QTextCharFormat::AlignNormal);
    formatForItem.setFontPointSize(8);

    QTextCharFormat formatForName;
    formatForName.setVerticalAlignment(QTextCharFormat::AlignNormal);
    formatForName.setFontPointSize(12);
    formatForName.setFontWeight(QFont::Bold);


    QList<QString> item;
    QList<size_t> quantity;
    QList<size_t> total;
    QList<QMap<QString, int>> topping;
    int toppingLength = 0;
    for(auto i = 0; i < listItem.count(); ++i) {
        item.append(QString(listItem.at(i).name + " (%1)").arg(((listItem.at(i).isSizeL) ? "L" : "M")));
        quantity.append(listItem.at(i).quantity);
        total.append(listItem.at(i).total);
        topping.append(listItem.at(i).toppings);
        if(listItem.at(i).toppings.isEmpty()) {
            continue;
        }
        toppingLength += listItem.at(i).toppings.count();
    }
    qreal billHeight = 85 + (listItem.length() + toppingLength) * 3.45;
    QPrinter printer;  // Use the default constructor for QPrinter

    // Set the custom paper size in millimeters
    QPageSize customPageSize(QSizeF(80, billHeight), QPageSize::Millimeter);
    printer.setPageSize(customPageSize);

    printer.setOutputFileName("coffee_invoice.pdf");
    printer.setOutputFormat(QPrinter::PdfFormat);

    QPainter painter;
    painter.begin(&printer);

    QString logoPath = ":/img/app_icon.ico"; // Replace with the actual path to your logo image
    QImage logoImage = QImage(logoPath).convertToFormat(QImage::Format_Grayscale8);

    qreal logoWidth = 40; // Adjust the logo width as needed
    qreal logoX = (printer.width() - logoWidth) / 2; // Center the logo horizontally
    qreal logoY = 5; // Adjust the Y position as needed

    painter.drawImage(QRectF(logoX, logoY, logoWidth, logoImage.height() / 4), logoImage);
    cursor.insertText("\n\n\n\n\n\n");

    cursor.insertText("        FINAL RECEIPT\n", formatForName);
    cursor.insertText(QString("  %1\n\n").arg(BillGenerator::address), QTextCharFormat());
    cursor.insertText(QString("Reciept ID: %1\n").arg(otherInfo.at(0)), QTextCharFormat());
    cursor.insertText(QString("Date: %1\n").arg(otherInfo.at(1)), QTextCharFormat());
    cursor.insertText(QString("Cashier: %1\n").arg(otherInfo.at(2)), QTextCharFormat());

    // Insert header labels into the first row
    QTextTable *table = cursor.insertTable(9 + listItem.length() + toppingLength, 3, tableFormat);
    table->cellAt(0, 0).firstCursorPosition().insertText("Items\t\t  ", formatForItem);
    table->cellAt(0, 1).firstCursorPosition().insertText("Q'ty   ", formatForItem);
    table->cellAt(0, 2).firstCursorPosition().insertText("Total", formatForItem);
    table->mergeCells(1, 0, 1, 3);
    table->cellAt(1, 0).firstCursorPosition().
        insertText("-----------------------------------------");

    // Sample data for the table
    int nextRow = 2;
    for (int i = 0; i < item.length(); ++i) {
        QTextTableCell itemsCell = table->cellAt(i + nextRow, 0);
        QTextTableCell quantityCell = table->cellAt(i + nextRow, 1);
        QTextTableCell totalCell = table->cellAt(i + nextRow, 2);

        itemsCell.firstCursorPosition().insertText(QString(item.at(i)), formatForItem);
        quantityCell.firstCursorPosition().insertText(QString::number(quantity.at(i)), formatForItem);
        totalCell.firstCursorPosition().insertText(QString(QString::number(total.at(i)) + ".000"), formatForItem);

        if(!topping.at(i).isEmpty()) {
            for(auto tp = topping.at(i).begin(); tp != topping.at(i).end(); ++tp) {
                QTextTableCell toppingCell = table->cellAt(i + ++nextRow, 0);
                table->mergeCells(i + nextRow, 0, 1, 3);
                toppingCell.firstCursorPosition().insertText(QString("  " + tp.key() + " (%1.000)").arg(tp.value()));
            }
        }
    }
    nextRow += item.length();
    table->mergeCells(nextRow, 0, 1, 3);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText("-----------------------------------------");

    table->mergeCells(++nextRow, 0, 1, 2);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText("Grand Total");
    table->cellAt(nextRow, 2).firstCursorPosition().insertText(QString("%1.000").arg(otherInfo.at(3).toInt()));

    table->mergeCells(++nextRow, 0, 1, 2);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText("CASH VND");
    table->cellAt(nextRow, 2).firstCursorPosition().insertText(QString("%1.000").arg(otherInfo.at(4).toInt()));

    table->mergeCells(++nextRow, 0, 1, 2);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText("Change CASH");
    table->cellAt(nextRow, 2).firstCursorPosition().insertText(QString("%1.000").
                                                               arg(otherInfo.at(4).toInt() - otherInfo.at(3).toInt()));

    table->mergeCells(++nextRow, 0, 1, 3);

    table->mergeCells(++nextRow, 0, 1, 3);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText("\tThank you homies!");

    table->mergeCells(++nextRow, 0, 1, 3);
    table->cellAt(nextRow, 0).firstCursorPosition().insertText(QString("           Pass wifi: %1").arg(BillGenerator::passWifi));

    // Render the QTextDocument onto the PDF
    doc.drawContents(&painter);
    delete table;
    painter.end();
    fromBillToDB();
    qDebug() << "print bill successfully.";
}



QChar genRandomLetter() {
    return QChar('A' + QRandomGenerator::global()->bounded(26));
}

QChar genRandomDigit() {
    return QChar('0' + QRandomGenerator::global()->bounded(10));
}

bool checkRcptExist(QString rcptId, QList<QString> list) {
    for(const QString &id : list) {
        if(rcptId == id) {
            return false;
        }
    }
    return true;
}

QString BillGenerator::generateRcptId() {
    QSqlQuery query;
    QList<QString> listRcptId;
    query.exec(QString("SELECT receipt_id FROM bills"));
    while (query.next()) {
        listRcptId.append(query.value(0).toString());
    }

    QString chain;
    do {
        chain = genRandomLetter();
        chain += genRandomLetter();

        for (int i = 0; i < 6; ++i) {
            chain += genRandomDigit();
        }
    } while (!checkRcptExist(chain, listRcptId));

    return chain;
}

void BillGenerator::fromBillToDB()
{
    QJsonArray itemsArr;

    for (const ItemModel &item : listItem) {
        QJsonObject jsonObject;
        jsonObject["id"] = QString::number(item.id);
        jsonObject["name"] = item.name;
        jsonObject["quantity"] = QString::number(item.quantity);
        jsonObject["size"] = (item.isSizeL) ? "L" : "M";

        QJsonArray tpArr;
        for (const QString &toppingName : item.toppings.keys()) {
            tpArr.append(toppingName);
        }
        jsonObject["toppings"] = tpArr;

        itemsArr.append(jsonObject);
    }

    // Create a JSON document from the JSON array
    QJsonDocument itemsDoc(itemsArr);

    // Convert the JSON document to a string
    QString jsonItems = itemsDoc.toJson(QJsonDocument::Indented);

    QSqlQuery query;

    // Prepare the SQL INSERT statement
    query.prepare("INSERT INTO bills (receipt_id, date_time, cashier, items, grand_total, cash_receive, cash_change)"
                  "VALUES (:receipt_id, :date_time, :cashier, :items, :grand_total, :cash_receive, :cash_change)");

    // Bind values to placeholders
    query.bindValue(":receipt_id", otherInfo.at(0));
    query.bindValue(":date_time", otherInfo.at(1));
    query.bindValue(":cashier", otherInfo.at(2));
    query.bindValue(":items", jsonItems);
    query.bindValue(":grand_total", otherInfo.at(3));
    query.bindValue(":cash_receive", otherInfo.at(4));
    query.bindValue(":cash_change", otherInfo.at(4).toInt() - otherInfo.at(3).toInt());
    //query.bindValue(":isCash", true);

    if (!query.exec()) {
        qDebug() << "failed";
    } else {
        qDebug() << "Data inserted successfully.";
    }
}

















