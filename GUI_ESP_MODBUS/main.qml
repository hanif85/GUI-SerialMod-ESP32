import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Controls.Universal 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.3

//import QSerialPort 1.0
import QSerialPortInfo 1.0
import QMLSerialPort 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: 1024
    height: 768
    title: "GUI ESP MODBUS"
    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange
    property var address: Array.from({ length: 256 }, (v, i) => i)
    property var fcode: Array.from({ length: 9 }, (v, i) => i)
    property int fontsize: 10
//    Material.T





    ListModel {
        id: contentModel
        /*ListElement {name: "param name"; submodel: []}*/
    }
    SerialPort{
        id: serialPort
        portName: serPort.currentValue
        baudRate: parseInt(serialBaudrate.currentValue)
        parity: parseInt(paritys.currentValue)
        flowControl: parseInt(flowControl.currentValue)
        stopBits: parseInt(stopBits.currentValue)

        property var buffer
        property var getDataSerial

        onDataReceived: {
//            console.log("Port: "+ portName+", Baudrate: "+ serialBaudrate.currentValue
//                        +", Data bits: " + serialDataBits.currentValue + ", Parity: " + paritys.currentValue
//                        + ", Flow Control: " + flowControl.currentValue + ", Stop BIt: " + stopBits.currentValue)

            buffer += data;
//            console.log(buffer)
            var end = buffer.indexOf("\r\n");
            if(end >= 0){
//                console.log(buffer.substring(0,end));
//                buffer = buffer.substring(end + 2);
                getDataSerial = buffer;
            }
            if(stopButton.stop){
                close()
                stopButton.stop = false
            }
        }
    }

    header: ToolBar {
        implicitHeight: contentHeight
        RowLayout {
            anchors.fill: parent
            MyToolButton {
//                text: qsTr("Button")
//                iconSource: //"qrc:/icon/save_to_file.png"
//                iconSourceDisabled: //"qrc:/icon/save_to_file_dis.png"
//                Material.background: Material.DeepOrange
                ToolTip.text: qsTr("Save log to file.")
//                onClicked: dialogFileSave.open()
            }
            MyToolButton {
//                iconSource: "qrc:/icon/clear_all.png"
//                iconSourceDisabled: "qrc:/icon/clear_all.png"
                ToolTip.text: qsTr("Clear log.")
//                onClicked: textArea.clear()
            }
            MyToolButton {
                Timer {
                    id: timer4serial
                    interval: 500; running: true; repeat: true
                    onTriggered: time.text = Date().toString()
                }

                Text { id: time }
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }
    RowLayout {
        id: row1
        spacing: 1
        Rectangle {
            id: rect1
            color: 'teal'
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
//            anchors.centerIn: parent.Center
//            Layout.minimumWidth: 50
            Layout.preferredWidth: appWindow.width/4
//            Layout.maximumWidth: 300
            Layout.preferredHeight: appWindow.height
            ColumnLayout{
                spacing: 2
                Text {
                    text: "PORT SETTINGS"
                    font.bold: true
                    font.pixelSize: 12
                }

                    Frame{
//                        anchors.horizontalCenter: rect1
//                        anchors.fill:  parent
//                        Layout.alignment: Qt.AlignCenter
                        background: Rectangle {
                            anchors.centerIn: rect1
                            Layout.preferredWidth: rect1.width
                            color: "transparent"
                            border.color: "#21be2b"
                            radius: 2
                        }
                        ColumnLayout{
//                            anchors.fill: rect1
//                            Layout.alignment: Qt.AlignCenter
                            RowLayout{
                                spacing: 40
//                                anchors.fill: rect1
                                Text {
                                    id: port
                                    text: qsTr("PORT")
                                    color: "black"
                                    font.bold: true
                                    font.pixelSize: 10
                                }
                                ComboBox {
                                    id: serPort
                                    font.pixelSize: 10
                                    property string portName;
                                    property variant portDelegateList;

                                    portName: portDelegateList[currentIndex]?portDelegateList[currentIndex].split(':')[0]:"";

                                    model:ListModel{}


                                    function updatePort(){
                                        portDelegateList = globalInfo.availablePorts
                                        model.clear()
                                        for (var i in portDelegateList){
                                            model.append( {text:portDelegateList[i].slice(portDelegateList[i].indexOf('::')+2)} )
                                        }
                                    }

                                    SerialPortInfo {
                                        id: globalInfo

                                        portDelegate: SerialPortInfo.PortName //+ SerialPortInfo.Description;

                                        onAvailablePortsChanged:updatePort()
                                    }

                                    Component.onCompleted:updatePort()

                                }

                            }

                            RowLayout{
//                                anchors.fill: parent
                                spacing:40
                                Text {
                                    id: baudRate
                                    text: qsTr("BAUD")
                                    font.bold: true
                                    font.pixelSize: fontsize
                                }
                                ComboBox {
                                    id: serialBaudrate
                                    model: [1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200]
                                    currentIndex: 3
                                    Layout.fillWidth: true
                                    editable: true
                                    font.pixelSize: fontsize
                                    function setIndex(baud) {
                                        for (var i = 0; i < model.length; i++) {
                                            if (model[i] === baud) {
                                                currentIndex = i
                                            }
                                        }
                                    }
                                }

                            }

                            RowLayout{
                                spacing: 20
                                Text {
                                    id: dataBit
                                    text: qsTr("DATA BIT")
                                    font.bold: true
                                    font.pixelSize: fontsize
                                }
                                ComboBox {
                                    id: serialDataBits
                                    model: [5, 6, 7, 8]
                                    currentIndex: 3
                                    Layout.fillWidth: true
                                    font.pixelSize: fontsize

                                    function setIndex(bits) {
                                        for (var i = 0; i < model.length; i++) {
                                            if (model[i] === bits) {
                                                currentIndex = i
                                            }
                                        }
                                    }
                                }


                            }

                            RowLayout{
                                spacing: 30
                                Text {
//                                    id: parity
                                    text: qsTr("PARITY")
                                    font.bold: true
                                    font.pixelSize: fontsize
                                }
                                ComboBox {
                                    id: paritys
                                    currentIndex: 0
                                    property var par
                                    textRole: "text"
                                    valueRole: "choice"
                                    font.pixelSize: fontsize
//                                    onActivated:
                                    onActivated: {
                                        par = parseInt(model.get(currentIndex).choice)
                                        console.log("Parity: " + par)
                                    }
                                    model: ListModel {
                                        ListElement { text: "No parity"; choice: SerialPort.NoParity }
                                        ListElement { text: "Even parity"; choice: SerialPort.EvenParity }
                                        ListElement { text: "Odd parity"; choice: SerialPort.OddParity }
                                        ListElement { text: "Space parity"; choice: SerialPort.SpaceParity }
                                        ListElement { text: "Mark parity"; choice: SerialPort.MarkParity }
                                    }
                                }
                            }

                            RowLayout{
                                spacing: 10
                                Text {
//                                    id: name
                                    text: qsTr("FLOW CTRL")
                                    font.bold: true
                                    font.pixelSize: fontsize
                                }
                                ComboBox {
                                    id: flowControl
                                    currentIndex: 0
                                    property var flowctrl
                                    textRole: "text"
                                    valueRole: "choice"
                                    font.pixelSize: fontsize
//                                    onActivated:
                                    onActivated: {
                                        flowctrl = parseInt(model.get(currentIndex).choice)
                                        console.log("Flow control: "+flowctrl)
                                    }
                                    model: ListModel {
                                        ListElement { text: "No flow control"; choice: SerialPort.NoFlowControl }
                                        ListElement { text: "Hardware control"; choice: SerialPort.HardwareControl }
                                        ListElement { text: "Software control"; choice: SerialPort.SoftwareControl }
                                    }
                                }
                            }

                            RowLayout{
                                spacing: 10
                                Text {
//                                    id: stopBits
                                    text: qsTr("STOP BITS")
                                    font.bold: true
                                    font.pixelSize: fontsize
                                }
                                ComboBox {
                                    id: stopBits
                                    currentIndex: 0
                                    property var stopbit
                                    textRole: "text"
                                    valueRole: "choice"
                                    font.pixelSize: fontsize
                                    onActivated: {
                                        stopbit = parseInt(model.get(currentIndex).choice)
                                        console.log("Stop bits: "+ stopbit)
                                    }
                                    model: ListModel {
                                        ListElement { text: "One stop bit"; choice: SerialPort.OneStop }
                                        ListElement { text: "One half stop bit"; choice: SerialPort.OneAndHalfStop }
                                        ListElement { text: "Two stop bits"; choice: SerialPort.TwoStop }
                                    }
//                                    width: window.width
                                }
                            }
                            RowLayout{
                                spacing : 0
                                RoundButton{
                                    id: openButton
                                    text: qsTr("Connect")
                                    Material.background:  "darkblue"
                                    font.pixelSize: fontsize
                                    property bool openport: false

                                    onClicked:{
                                        console.log("Port: "+ serPort.currentValue+", Baudrate: "+ serialBaudrate.currentValue
                                                    +", Data bits: " + serialDataBits.currentValue + ", Parity: " + paritys.currentValue
                                                    + ", Flow Control: " + flowControl.currentValue + ", Stop BIt: " + stopBits.currentValue)
                                        stopButton.stop = false
                                        serialPort.open()
                                        openButton = true
                                    }
                                }
                                RoundButton{
                                    id: stopButton
                                    text: qsTr("Disconnect")

                                    Material.background:  "black"
                                    property bool stop: false
                                    font.pixelSize: fontsize
                                    onClicked: {
                                        openButton.openport = false
                                        sendData.sendmodbus["start"] = 0


                                        console.log(JSON.stringify(sendData.sendmodbus))
                                        serialPort.sendData(JSON.stringify(sendData.sendmodbus))
                                        stop = true

//                                        clos
//                                        dataSerial.remove()
                                    }

                                }
                                RoundButton{
                                    text: qsTr("Refresh")
                                    Material.background:  "black"
                                    font.pixelSize: fontsize
                                    onClicked: {
                                        serPort.updatePort()
                                    }
                                }
                            }

                        }
                    }



                    Text {
                        id: modbusReg
                        text: qsTr("Modbus Register")
                        font.bold: true
                        font.pixelSize: 15
                    }
                    Frame{
                        Layout.alignment: Qt.AlignCenter
                        background: Rectangle {
//                            anchors.fill: parent
                            color: "transparent"
                            border.color: "#21be2b"
                            radius: 2
                        }
                        RowLayout{
                                ColumnLayout{
                                    RowLayout{
                                        spacing: 30
                                        Text {
                                            id: devAddr
                                            text: qsTr("Device Addr")
                                            font.bold: true
                                            font.pixelSize: fontsize
                                        }
                                        ComboBox {
                                            id: deviceAddress
                                            editable: true
                                            model: address
                                            font.pixelSize: fontsize
                                            onSelectTextByMouseChanged: {
                                                console.log(currentIndex + " " + currentText)
                                            }

                                            function setIndex(type) {
                                                for (var i = 0; i < model.count; i++) {
                                                    if (model.get(i).type === type) {
                                                        currentIndex = i

                                                    }
                                                }
                                            }
                                        }

                                    }

                                    RowLayout{
                                        spacing: 40
                                        Layout.preferredWidth: 3/4 * (rect1.width)
                                        Text {
                                            id: funcCode
                                            text: qsTr("Func Code")
                                            font.bold: true
                                            font.pixelSize: fontsize
                                        }
                                        ComboBox {
                                            id: functionCode
                                            textRole: "text"
                                            font.pixelSize: fontsize
                                            property var getdata
                                            model: ListModel {
                                                ListElement {text: qsTr("[0x01] Read coils"); code: 0x01}
                                                ListElement {text: qsTr("[0x02] Read discrete inputs"); code: 0x02}
                                                ListElement {text: qsTr("[0x03] Read holding registers"); code: 0x03}
                                                ListElement {text: qsTr("[0x04] Read input registers"); code: 0x04}
                                                ListElement {text: qsTr("[0x05] Write single coil"); code: 0x05}
                                                ListElement {text: qsTr("[0x06] Write single register"); code: 0x06}
                                                ListElement {text: qsTr("[0x0F] Write multiple coils"); code: 0x0F}
                                                ListElement {text: qsTr("[0x10] Write multiple registers"); code: 0x10}
                                            }
                                            Layout.fillWidth: true
                                            function showSettings() {
                                                if (parameterType === "read") {
                                                    settedValue.visible = false
                                                    labelSettedValue.visible = false
                                                } else if (parameterType === "write") {
                                                    settedValue.visible = true
                                                    labelSettedValue.visible = true
                                                } else {
                                                    settedValue.visible = false
                                                    labelSettedValue.visible = false
                                                }
                                            }
                                            function setIndex(code) {
                                                for (var i = 0; i < model.count; i++) {
                                                    if (model.get(i).code === code) {
                                                        currentIndex = i
                                                    }
                                                }
                                            }
                                            function determineType() {
                                                getdata = model.get(currentIndex).code
                                                if (currentIndex >= 0) {
                                                    switch (model.get(currentIndex).code) {
                                                        case 0x01:
                                                        case 0x02:
                                                        case 0x03:
                                                        case 0x04:
                                                            parameterType = "read"
                                                            break
                                                        case 0x05:
                                                        case 0x06:
                                                        case 0x0F:
                                                        case 0x10:
                                                            parameterType = "write"
                                                            break
                                                    }
                                                }
                                            }
                                            function determineCount() {
                                                if (currentIndex >= 0) {
                                                    switch (model.get(currentIndex).code) {
                                                        case 0x01:
                                                        case 0x02:
                                                            registersCount.number.to = 0x07D0
                                                            break
                                                        case 0x0F:
                                                            if (registersCount.number.value > 0x07B0) {
                                                                registersCount.number.value = 1
                                                                registersCount.number.contentItem.text = "1"
                                                            }
                                                            registersCount.number.to = 0x07B0
                                                            break
                                                        case 0x03:
                                                        case 0x04:
                                                            if (registersCount.number.value > 0x7D) {
                                                                registersCount.number.value = 1
                                                                registersCount.number.contentItem.text = "1"
                                                            }
                                                            registersCount.number.to = 0x7D
                                                            break
                                                        case 0x10:
                                                            if (registersCount.number.value > 0x7B) {
                                                                registersCount.number.value = 1
                                                                registersCount.number.contentItem.text = "1"
                                                            }
                                                            registersCount.number.to = 0x7B
                                                            break
                                                        case 0x05:
                                                        case 0x06:
                                                            registersCount.number.value = 1
                                                            registersCount.number.contentItem.text = "1"
                                                            registersCount.number.from = 1
                                                            registersCount.number.to = 1
                                                            break
                                                    }
                                                }
                                            }

                                            onActivated: {
                                                determineType()
                                                showSettings()
                                                determineCount()
                                            }
                                            onVisibleChanged: {
                                                if (visible) {
                                                    determineType()
                                                    showSettings()
                                                    determineCount()
                                                } else {
                                                    registersCount.number.to = 0x07D0
                                                }
                                            }
                                        }

                                    }

                                    RowLayout{
                                        spacing: 20
                                        Text {
                                            id: regAddr
                                            text: qsTr("Register Addr")
                                            font.bold: true
                                            font.pixelSize: fontsize
                                        }
                                        TextField{
                                            id: registerAddress
                                            placeholderText: "1"
                                            font.pixelSize: fontsize
                                        }
                                    }

                                    RowLayout{
                                        spacing: 65
                                        Text {
                                            id: cnt
                                            text: qsTr("Count")
                                            font.bold: true
                                            font.pixelSize: fontsize
                                        }
                                        TextField{
                                            id: countReg
                                            placeholderText: "1"
                                            font.pixelSize: fontsize
                                        }

                                    }
                                    RowLayout{
                                        RoundButton{
                                            id:sendData
                                            font.pixelSize: fontsize
                                            text: "Send Modbus"
                                            Material.background: "red"
                                            property var sendmodbus: {
                                                "start":0,
                                                "deviceAddr":0,
                                                "funcCode":0,
                                                "registerAddr":0,
                                                "countRegister":0
                                            }

//                                            id: sendModbus

                                            onClicked: {
                                                sendData.sendmodbus["start"] = 1
                                                sendData.sendmodbus["deviceAddr"] = deviceAddress.currentValue
                                                sendData.sendmodbus[ "funcCode"] = functionCode.getdata
                                                sendData.sendmodbus["registerAddr"] = parseInt(registerAddress.text)
                                                sendData.sendmodbus["countRegister"] = parseInt(countReg.text)
//                                                send
                                                writeinput.text += JSON.stringify(sendData.sendmodbus) +"\r\n"
                                                console.log(JSON.stringify(sendData.sendmodbus))
                                                serialPort.sendData(JSON.stringify(sendData.sendmodbus))
                                                timer4serial.start()
                                            }
                                        }

                                        RoundButton{
                                            id:stopModButton
                                            font.pixelSize: fontsize
                                            Material.background: "blue"
                                            text: "stop Modbus"
                                            onClicked: {
                                                timer4serial.stop()
                                            }
                                        }
                                    }

                            }

//                            Rectangle{
//                                id: rect4
//                                Layout.fillWidth: true
//                                Layout.preferredWidth: rect1.width/2
//                                Layout.preferredHeight: rect1/5
//                                color: "grey"
//                            }
                        }
                    }
            }


        }
        Rectangle {
            id: rect2
            color: "grey"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
//            Layout.minimumWidth: 100
            Layout.preferredWidth: appWindow.width*4/5
            Layout.preferredHeight: appWindow.height
            ColumnLayout{
                spacing: 5

                    Rectangle {
                        id: rect3
                        Layout.alignment: Qt.AlignCenter
                        color: "black"
                        Layout.preferredWidth: rect2.width
                        Layout.preferredHeight: rect2.height/2
                        ScrollView{
                            width: rect3.width-10
                            height: rect3.height
                            clip: true
                            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                            ScrollBar.vertical.policy: ScrollBar.AsNeeded
//                            onContentHeightChanged: {
//                                if (autoScroll) {
//                                    ScrollBar.vertical.position = 1 - ScrollBar.vertical.size
//                                }
//                            }
                            Text{
                                id: dataSerial
                                text: serialPort.buffer
                                color: "white"
                                font.pixelSize: 14
                            }
                        }



                    }

                    Rectangle {
                        id: rectinput
                        Layout.alignment: Qt.AlignRight
                        color: "teal"
                        Layout.preferredWidth: rect2.width
                        Layout.preferredHeight: rect2.height/2
                        ColumnLayout{
                            Rectangle{
                                id: inputRect
                                Layout.alignment: Qt.AlignCenter
                                color: "black"
                                Layout.preferredWidth: rectinput.width - 50
                                Layout.preferredHeight: 3* rectinput.height/5
//                                Text{
//                                    id: writeinput
////                                    text: writeText.text
//                                    color: "white"
//                                    font.pixelSize: 14
//                                }
                                ScrollView{
                                    width: inputRect.width
                                    height: inputRect.height
                                    clip: true
                                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
        //                            onContentHeightChanged: {
        //                                if (autoScroll) {
        //                                    ScrollBar.vertical.position = 1 - ScrollBar.vertical.size
        //                                }
        //                            }
                                    Text{
                                        id: writeinput
//                                        text: serialPort.buffer
                                        color: "white"
                                        font.pixelSize: 14
                                    }
                                }
                            }
                            RowLayout{
                                TextField{
                                    id: writeText
                                    placeholderText: "write here"
                                    implicitWidth:  rectinput.width - (appWindow.width/8)
                                    background: Rectangle{
                                        color: "black"
                                    }
                                }

                                RoundButton{
                                    id: sendButton
                                    Material.background:  "blue"
                                    text: "SEND"
                                    onClicked: {
                                        if (openButton.openport){
                                            writeinput.text = writeText.text
                                            serialPort.sendData(writeinput.text)
                                        } else {
                                            writeinput.text = "Please, Check connection!!"
                                        }


                                    }
                                }
                            }
                        }
                    }

//                    Rectangle {
//                        Layout.alignment: Qt.AlignBottom
//                        Layout.fillHeight: true
//                        color: "blue"
//                        Layout.preferredWidth: 70
//                        Layout.preferredHeight: 40
//                    }

            }



//            ScrollView {
//                id: view
//                width: rect2.width
//                height: rect2.height/2
//                anchors.fill: rect2
//                Layout.alignment: Qt.AlignRight
//                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
////                ListView {
////                         model: ListModel{}
////                         delegate: ItemDelegate {
////                             text: serialPort.buffer + index
////                         }
////                     }
//                TextArea {
//                    text: serialPort.buffer
//                }

//            }
//            StackLayout {
//                id: layout
//                anchors.fill: parent
//                currentIndex: 1
//                Rectangle {
//                    color: 'teal'
//                    implicitWidth: 200
//                    implicitHeight: 200
//                }
//                Rectangle {
//                    color: 'plum'
//                    implicitWidth: 300
//                    implicitHeight: 200
//                }
//            }


//            Text {
////                anchors.centerIn: parent
//                text: "PORT SETTINGS"
//            }
        }
    }



//    Column{
//        id: col
//        spacing: 5

//        TextField{
//            id: portName
//            width: window.width
//            text: "COM4"
//            placeholderText: "Port name (e.g COM4 or /dev/ttyUSB0)"
//        }
//        TextField{
//            id: baudRate
//            width: window.width
//            text: "921600"
//            placeholderText: "Baud rate (e.g 115200)"
//        }
//        ComboBox {
//            id: parity
//            currentIndex: 0
//            model: ListModel {
//                ListElement { text: "No parity"; choice: SerialPort.NoParity }
//                ListElement { text: "Even parity"; choice: SerialPort.EvenParity }
//                ListElement { text: "Odd parity"; choice: SerialPort.OddParity }
//                ListElement { text: "Space parity"; choice: SerialPort.SpaceParity }
//                ListElement { text: "Mark parity"; choice: SerialPort.MarkParity }
//            }
//            width: window.width
//        }
//        ComboBox {
//            id: flowControl
//            currentIndex: 0
//            model: ListModel {
//                ListElement { text: "No flow control"; choice: SerialPort.NoFlowControl }
//                ListElement { text: "Hardware control"; choice: SerialPort.HardwareControl }
//                ListElement { text: "Software control"; choice: SerialPort.SoftwareControl }
//            }
//            width: window.width
//        }
//        ComboBox {
//            id: stopBits
//            currentIndex: 0
//            model: ListModel {
//                ListElement { text: "One stop bit"; choice: SerialPort.OneStop }
//                ListElement { text: "One half stop bit"; choice: SerialPort.OneAndHalfStop }
//                ListElement { text: "Two stop bits"; choice: SerialPort.TwoStop }
//            }
//            width: window.width
//        }
//        Button {
//            text: "Open"
//            onClicked: serialPort.open()
//        }
//    }
}

