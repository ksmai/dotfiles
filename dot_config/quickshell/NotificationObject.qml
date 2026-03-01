import QtQml
import Quickshell.Services.Notifications

QtObject {
    property Notification notification
    property string output
    property string timeString
    property Connections connections

    property int notificationId: notification ? notification.id : _notificationId
    property string appIcon: notification ? notification.appIcon : _appIcon
    property string appName: notification ? notification.appName : _appName
    property string image: notification ? notification.image : _image
    property string summary: notification ? notification.summary : _summary
    property string body: notification ? notification.body : _body
    property list<var> actions: notification ? notification.actions : (_actions ?? [])

    property int _notificationId
    property string _appIcon
    property string _appName
    property string _image
    property string _summary
    property string _body
    property list<var> _actions

    component Action: QtObject {
        id: actionComponent
        property string text

        function invoke() {
        }
    }

    function dismiss() {
        if (notification) {
            notification.dismiss();
        }
    }

    function copyOnDismiss() {
        _notificationId = notification?.id;
        _appIcon = notification?.appIcon;
        _appName = notification?.appName;
        _image = notification?.image;
        _summary = notification?.summary;
        _body = notification?.body;
        _actions = notification?.actions?.map(action => ({
                    text: action?.text ?? "",
                    invoke: () => {}
                }));
    }
}
