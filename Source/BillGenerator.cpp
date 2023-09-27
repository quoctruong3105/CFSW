#include "Include/BillGenerator.h"
#include <QTextTableCell>

BillGenerator::BillGenerator(QObject *parent) : QObject{parent} {

}

void BillGenerator::collectItemInfo(int id, QString name, int total, int quantity, const QString &extraJson)
{
    ItemModel item;
    item.id = id;
    item.name = name;
    item.total = total;
    item.quantity = quantity;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(extraJson.toUtf8());
    QVariantMap extra = jsonDoc.toVariant().toMap();
    for(auto topping = extra.constBegin(); topping != extra.constEnd(); topping++) {
        QString tpName = topping.key();
        int tpCost = topping.value().toInt();
        item.toppings.insert(tpName, tpCost);
    }
    listItem.append(item);
}

void BillGenerator::collectOtherInfo(long, QString, int, int)
{

}

void BillGenerator::print()
{
    qDebug() << "---------------------------------------------";
    for (const ItemModel &it : listItem) {
        qDebug() << it.id << "\t" << it.name << "\t\t" << it.total << "\t" << it.quantity;
        for(auto topping = it.toppings.begin(); topping != it.toppings.end(); topping++) {
            qDebug() << "\t" << topping.key() << "\t\t\t" << topping.value();
        }
    }
    qDebug() << "---------------------------------------------";
}

void BillGenerator::clearListItem()
{
    this->listItem.clear();
}

void BillGenerator::printBill()
{
    // Calculate the required paper length based on the number of items
    qreal billHeight = 100 + this->listItem.length() * 3.5277778; // Adjust as needed

    QPrinter printer;  // Use the default constructor for QPrinter

    // Set the custom paper size in millimeters
    QPageSize customPageSize(QSizeF(80, billHeight), QPageSize::Millimeter);
    printer.setPageSize(customPageSize);

    printer.setOutputFileName("coffee_invoice.pdf");
    printer.setOutputFormat(QPrinter::PdfFormat);

    QPainter painter;
    painter.begin(&printer);

    // Create a QTextDocument for text rendering
    QTextDocument doc;
    doc.setDefaultFont(QFont("Courier new", 8)); // You can change the font and size as needed
    QTextCursor cursor(&doc);

    QString logoPath = ":/img/app_icon.ico"; // Replace with the actual path to your logo image
    QImage logoImage(logoPath);
    qreal logoWidth = 40; // Adjust the logo width as needed
    qreal logoX = (printer.width() - logoWidth) / 2; // Center the logo horizontally
    qreal logoY = 5; // Adjust the Y position as needed

    painter.drawImage(QRectF(logoX, logoY, logoWidth, logoImage.height() / 4), logoImage);
    cursor.insertText("\n\n\n\n\n\n");

    cursor.insertText("Reciept No: 5435234\n", QTextCharFormat());
    cursor.insertText("Date: \n", QTextCharFormat());
    cursor.insertText("Name: Name\n", QTextCharFormat());
    cursor.insertText("Station: VN\n", QTextCharFormat());


    // Modify the QTextTableFormat to remove table borders
    QTextTableFormat tableFormat;
    tableFormat.setWidth(100);
    tableFormat.setAlignment(Qt::AlignCenter);
    tableFormat.setCellPadding(0);
    tableFormat.setCellSpacing(0);
    tableFormat.setBorder(0); // Set the border width to 0

    QTextCharFormat formatForName;
    formatForName.setVerticalAlignment(QTextCharFormat::AlignNormal);
    formatForName.setFontPointSize(8);

    // Define column widths using QTextLength
    QTextLength columnWidth1(QTextLength::PercentageLength, 40);  // 40% of the table width
    QTextLength columnWidth2(QTextLength::PercentageLength, 20);  // 30% of the table width
    QTextLength columnWidth3(QTextLength::PercentageLength, 20);  // 30% of the table width
    QList<QTextLength> columnWidths;
    columnWidths << columnWidth1 << columnWidth2 << columnWidth3;
    tableFormat.setColumnWidthConstraints(columnWidths);

    // Insert header labels into the first row

    QTextTable *table = cursor.insertTable(3, 3, tableFormat);
    table->cellAt(0, 0).firstCursorPosition().insertText("Items\t\t  ", formatForName);
    table->cellAt(0, 1).firstCursorPosition().insertText("Q'ty   ", formatForName);
    table->cellAt(0, 2).firstCursorPosition().insertText("Total", formatForName);
    table->mergeCells(1, 0, 1, 3);
    table->cellAt(1, 0).firstCursorPosition().
        insertText("-----------------------------------------");

    // Sample data for the table
    QList<QString> item;
    QList<size_t> quantity;
    QList<size_t> total;
    QList<QMap<QString, int>> topping;
    for(const ItemModel &it : listItem) {
        item.append(it.name);
        quantity.append(it.quantity);
        total.append(it.total);
        topping.append(it.toppings);
    }

    int nextRow = 2;
    for (int i = 0; i < item.length(); ++i) {
        if(!topping.at(i).isEmpty()) {
            table->appendRows(1 + topping.length());
        } else {
            table->appendRows(1);
        }
        QTextTableCell itemsCell = table->cellAt(i + nextRow, 0);
        QTextTableCell quantityCell = table->cellAt(i + nextRow, 1);
        QTextTableCell totalCell = table->cellAt(i + nextRow, 2);

        itemsCell.firstCursorPosition().insertText(QString(item.at(i)), formatForName);
        quantityCell.firstCursorPosition().insertText(QString::number(quantity.at(i)), formatForName);
        totalCell.firstCursorPosition().insertText(QString(QString::number(total.at(i)) + ".000"), formatForName);

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
    table->cellAt(nextRow, 0).firstCursorPosition().
        insertText("-----------------------------------------");


    // Render the QTextDocument onto the PDF
    doc.drawContents(&painter);

    painter.end();
    qDebug() << "print bill success";
}

















