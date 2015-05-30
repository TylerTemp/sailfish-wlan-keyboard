var AppDispatcher = require('../dispatcher/AppDispatcher');
var EventEmmiter = require('events').EventEmitter;
var WlanKeyboardConstants = require('../constants/WlanKeyboardConstants');
var assign = require('object-assign');
var JollaAppConnection = require('../utils/JollaAppConnection');

var CHANGE_EVENT = 'change';

var _serverSettings = {};

var _connectionStatus = {};

var _keyMode = _keyMode || WlanKeyboardConstants.KeyMode.HEADLESS;

var WlanKeyboardStore = assign({}, EventEmmiter.prototype, {

    emitChange: function () {
        this.emit(CHANGE_EVENT);
    },

    addChangeListener: function (callback) {
        this.on(CHANGE_EVENT, callback);
    },

    removeChangeListener: function (callback) {
        this.removeListener(callback);
    },


    getServerSettings: function() {
        return _serverSettings;
    },

    getKeyMode: function() {
        return _keyMode;
    },

    updateKeyMode: function(keyMode) {
        _keyMode = keyMode;
        this.emitChange();
    },

    getConnectionStatus: function() {
        return _connectionStatus;
    },

    updateConnectionStatus: function(status) {
        _connectionStatus = status;
        this.emitChange();
    },

    updateServerSettings: function(s) {
        _serverSettings = s;
        console.log(s);
        this.updateKeyMode(s.keyboardMode);
        this.emitChange();
    }

});

AppDispatcher.register(function(action) {

    switch (action.type) {
        case WlanKeyboardConstants.ActionTypes.RECEIVE_SETTINGS:
            // layout:
            //    data": {
            //        "autostart": true,
            //        "connectionInterface": "wlan0",
            //        "connectionInterfaceIndex": 0,
            //        "firstRun": false,
            //        "headlessMode": 0,
            //        "httpPort": 7779,
            //        "keyboardMode": 1,
            //        "useAnyConnection": false,
            //        "useHttps": false,
            //        "wsPort": 7784
            //    }

            console.log(action.settings);
            WlanKeyboardStore.updateServerSettings(action.settings);
            break;

        case WlanKeyboardConstants.ActionTypes.SEND_TEXT:
            JollaAppConnection.sendText(action.text);
            break;

        case WlanKeyboardConstants.ActionTypes.SEND_KEY_ENTER:
            JollaAppConnection.sendKeyEnter();
            break;

        case WlanKeyboardConstants.ActionTypes.SEND_KEY_DEL:
            JollaAppConnection.sendKeyDel();
            break;

        case WlanKeyboardConstants.ActionTypes.SEND_KEY_ARROW:
            JollaAppConnection.sendKeyArrow(action.direction);
            break;

        case WlanKeyboardConstants.ActionTypes.KEY_MODE_CHANGED:
            WlanKeyboardStore.updateKeyMode(action.keyMode);
            break;

        case WlanKeyboardConstants.ActionTypes.CONNECTION_STATUS_CHANGED:
                WlanKeyboardStore.updateConnectionStatus(action.status);
                if (action.status != WlanKeyboardStore.getConnectionStatus) {
                    WlanKeyboardStore.updateConnectionStatus(action.status);
                }
            break;

        default:
            break;
    }
});


module.exports = WlanKeyboardStore;