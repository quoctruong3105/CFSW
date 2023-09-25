#include "Include/BillGenerator.h"

BillGenerator::BillGenerator(QObject *parent) : QObject{parent} {

}

void BillGenerator::collectItemInfo(int id, QString name, int cost, int quantity, const QString &extraJson)
{
    ItemModel item;
    item.id = id;
    item.name = name;
    item.cost = cost;
    item.quantity = quantity;
    qDebug() << item.id << "\t" << item.name << "\t\t" << item.cost << "\t" << item.quantity;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(extraJson.toUtf8());
    QVariantMap extra = jsonDoc.toVariant().toMap();
    for(auto topping = extra.constBegin(); topping != extra.constEnd(); topping++) {
        QString tpName = topping.key();
        int tpCost = topping.value().toInt();
        item.toppings.insert(tpName, tpCost);
        qDebug() << tpName << "  " << tpCost;
    }
}

void BillGenerator::print()
{
    for (const ItemModel &it : listItem) {
        qDebug() << it.id << "\t" << it.name << "\t" << it.cost << "\t" << it.quantity;

        // Access and iterate through the list of QVariantMap for each ItemModel
        for (const QVariant &variant : it.toppings) {
            if (variant.canConvert<QVariantMap>()) {
                QVariantMap map = variant.toMap();

                // Process the QVariantMap as needed
                for (auto mapIter = map.constBegin(); mapIter != map.constEnd(); ++mapIter) {
                    qDebug() << "Topping Key:" << mapIter.key() << "\tTopping Value:" << mapIter.value();
                }
            } else {
                qDebug() << "Toppings variant cannot be converted to QVariantMap.";
            }
        }
    }
}

void BillGenerator::clearListItem()
{
    this->listItem.clear();
}

void BillGenerator::printBill()
{
    // Define the number of items in your list
    int numberOfItems = 60; // You can set this value based on your data

    // Calculate the required paper length based on the number of items
    qreal paperHeight = 100.0 + numberOfItems * 4.0; // Adjust as needed

    QPrinter printer;  // Use the default constructor for QPrinter

    // Set the custom paper size in millimeters
    QPageSize customPageSize(QSizeF(80, paperHeight), QPageSize::Millimeter);
    printer.setPageSize(customPageSize);

    printer.setOutputFileName("coffee_invoice.pdf");
    printer.setOutputFormat(QPrinter::PdfFormat);

    QPainter painter;
    painter.begin(&printer);

    // Create a QTextDocument for text rendering
    QTextDocument doc;
    doc.setDefaultFont(QFont("Arial", 10)); // You can change the font and size as needed
    QTextCursor cursor(&doc);

    // Start adding text and formatting based on the provided template
    cursor.insertText("Coffee Invoice\n", QTextCharFormat());
    cursor.insertText("--------------------------------------------\n", QTextCharFormat());
    cursor.insertText("Invoice No: [Your Invoice Number]\n", QTextCharFormat());
    cursor.insertText("Date: [Invoice Date]\n", QTextCharFormat());
    cursor.insertText("\nCustomer Information:\n", QTextCharFormat());
    cursor.insertText("Name: [Customer Name]\n", QTextCharFormat());
    cursor.insertText("Email: [Customer Email]\n", QTextCharFormat());
    cursor.insertText("Phone: [Customer Phone]\n", QTextCharFormat());
    cursor.insertText("\n---------------------------------------------\n", QTextCharFormat());
    cursor.insertText("| Item         | Quantity | Price  | Total  |  \n", QTextCharFormat());
    cursor.insertText("|--------------|----------|--------|--------|  \n", QTextCharFormat());

    // Add dynamic content for items (adjust as needed based on your data)
    for (int i = 0; i < numberOfItems; ++i) {
        cursor.insertText("| Espresso     | [Qty1]   | [$1.50]| [$X.XX]|  \n", QTextCharFormat());
        // Add more items as needed
    }

    cursor.insertText("-----------------------------------------------\n", QTextCharFormat());
    cursor.insertText("Subtotal: [$X.XX]\n", QTextCharFormat());
    cursor.insertText("Tax (8%): [$X.XX]\n", QTextCharFormat());
    cursor.insertText("Total: [$X.XX]\n", QTextCharFormat());
    cursor.insertText("\nPayment Information:\n", QTextCharFormat());
    cursor.insertText("Payment Method: [Payment Method]\n", QTextCharFormat());
    cursor.insertText("\nThank you for choosing [Your Coffee Shop Name]!\n", QTextCharFormat());

    // Render the QTextDocument onto the PDF
    qDebug() << ("rewrew");
    doc.drawContents(&painter);

    painter.end();
}







