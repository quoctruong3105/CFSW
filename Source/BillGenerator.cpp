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

//void BillGenerator::printBill()
//{
//    // Calculate the required paper length based on the number of items
//    qreal billHeight = 100 + this->listItem.length() * 3.5277778; // Adjust as needed

//    QPrinter printer;  // Use the default constructor for QPrinter

//    // Set the custom paper size in millimeters
//    QPageSize customPageSize(QSizeF(80, billHeight), QPageSize::Millimeter);
//    printer.setPageSize(customPageSize);

//    printer.setOutputFileName("coffee_invoice.pdf");
//    printer.setOutputFormat(QPrinter::PdfFormat);

//    QPainter painter;
//    painter.begin(&printer);

//    // Create a QTextDocument for text rendering
//    QTextDocument doc;
//    doc.setDefaultFont(QFont("Arial", 8)); // You can change the font and size as needed
//    QTextCursor cursor(&doc);

//    QString logoPath = ":/img/app_icon.ico"; // Replace with the actual path to your logo image
//    QImage logoImage(logoPath);
//    qreal logoWidth = 40; // Adjust the logo width as needed
//    qreal logoX = (printer.width() - logoWidth) / 2; // Center the logo horizontally
//    qreal logoY = 5; // Adjust the Y position as needed

//    painter.drawImage(QRectF(logoX, logoY, logoWidth, logoImage.height() / 4), logoImage);
//    cursor.insertText("\n\n\n\n\n");

//    QTextCharFormat largerBoldFont;
//    largerBoldFont.setFontWeight(QFont::Bold);
//    largerBoldFont.setFontPointSize(14); // Set the font size to 16 (adjust as needed)

//    QTextTableCellFormat

//    QTextCursor centerText = cursor;
//    centerText.mergeCharFormat(largerBoldFont);
//    centerText.insertText("Coffee Invoice\n", largerBoldFont);
//    cursor.insertText("Reciept No: 5435234\n", QTextCharFormat());
//    cursor.insertText("Date: [Invoice Date]\n", QTextCharFormat());
//    cursor.insertText("Tên: [Customer Name]\n", QTextCharFormat());
//    cursor.insertText("Station: [Customer Email]\n", QTextCharFormat());
//    cursor.insertText("Items\t\tQ'ty\tTotal\n", QTextCharFormat());
//    cursor.insertText("------------------------------------------------------------------------\n", QTextCharFormat());
//    for (int i = 0; i < listItem.length(); ++i) {
//        ItemModel item = listItem.at(i);
//        cursor.insertText(QString("%1\t\t%2\t%3.000\n").arg(item.name).arg(item.quantity).arg(item.total), QTextCharFormat());
//    }

//    cursor.insertText("------------------------------------------\n", QTextCharFormat());
//    cursor.insertText("Subtotal: [$X.XX]\n", QTextCharFormat());
//    cursor.insertText("Tax (8%): [$X.XX]\n", QTextCharFormat());
//    cursor.insertText("Total: [$X.XX]\n", QTextCharFormat());
//    cursor.insertText("\nPayment Information:\n", QTextCharFormat());
//    cursor.insertText("Payment Method: [Payment Method]\n", QTextCharFormat());
//    cursor.insertText("\nThank you for choosing [Your Coffee Shop Name]!\n", QTextCharFormat());

//    // Render the QTextDocument onto the PDF
//    doc.drawContents(&painter);

//    painter.end();
//    qDebug() << "print bill success";
//}

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
    cursor.insertText("\n\n\n\n\n");

    QTextCharFormat largerBoldFont;
    largerBoldFont.setFontWeight(QFont::Bold);
    largerBoldFont.setFontPointSize(14); // Set the font size to 16 (adjust as needed)

    QTextCursor centerText = cursor;
    centerText.mergeCharFormat(largerBoldFont);
    centerText.insertText("Coffee Invoice\n", largerBoldFont);
    cursor.insertText("Reciept No: 5435234\n", QTextCharFormat());
    cursor.insertText("Date: [Invoice Date]\n", QTextCharFormat());
    cursor.insertText("Tên: [Customer Name]\n", QTextCharFormat());
        cursor.insertText("Station: [Customer Email]\n", QTextCharFormat());

    // Modify the QTextTableFormat to remove table borders
    QTextTableFormat tableFormat;
    tableFormat.setAlignment(Qt::AlignLeft);
    tableFormat.setCellPadding(2);
    tableFormat.setCellSpacing(0);

    // Remove table borders
    tableFormat.setBorder(0); // Set the border width to 0

    // Define the table's width
    tableFormat.setWidth(QTextLength(QTextLength::PercentageLength, 100)); // 100% width

    QTextTable *table = cursor.insertTable(1, 3, tableFormat);

    // Set column widths using the table format
    QTextLength columnWidth1(QTextLength::PercentageLength, 60); // 60% for drink name
    QTextLength columnWidth2(QTextLength::PercentageLength, 20); // 20% for quantity
    QTextLength columnWidth3(QTextLength::PercentageLength, 20); // 20% for cost

    tableFormat.setColumnWidthConstraints(QVector<QTextLength>() << columnWidth1 << columnWidth2 << columnWidth3);

    // Sample data for the table
    QList<QString> items = { "Nước cam tươi\t", "Sữa chua trái cây", "Sinh tố bơ" };
    QList<int> quantities = { 1, 1, 1 };
    QList<double> totals = { 12.0, 18.0, 25.0 };

    // Insert sample data into the table
    for (int i = 0; i < items.length(); ++i) {
        table->appendRows(1); // Insert a new row
        QTextTableCell itemsCell = table->cellAt(i + 1, 0);
        QTextTableCell quantityCell = table->cellAt(i + 1, 1);
        QTextTableCell totalCell = table->cellAt(i + 1, 2);

        itemsCell.firstCursorPosition().insertText(items[i]);
        quantityCell.firstCursorPosition().insertText(QString::number(quantities[i]));
        totalCell.firstCursorPosition().insertText(QString::number(totals[i], 'f', 3));
    }

    // Render the QTextDocument onto the PDF
    doc.drawContents(&painter);

    painter.end();
    qDebug() << "print bill success";
}

















