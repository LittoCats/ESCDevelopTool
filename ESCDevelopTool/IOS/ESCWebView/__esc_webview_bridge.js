// Generated by CoffeeScript 1.8.0
(function() {
  var __ESCWebView_Bridge, __ESCWebView_Bridge_Arguments_Analyzer, __ESCWebView_Bridge_Arguments_Wrapper;

  this.__ESCWebViewBridge_SerializeNo_ = 0;

  this.__ESCWebView_Bridge_Function_Wrapper_SerializeNo_ = 0;

  this.__ESCWebView_Bridge_Function_Wrapper_ = {};

  this.__ESCWebView_registeNativeCallback_ = function(name) {
    if (name.length === 0) {
      return null;
    }
    return this[name] = function() {
      var args;
      args = Array.prototype.slice.call(arguments);
      args.push(name);
      return __ESCWebView_Bridge.apply(null, args);
    };
  };

  __ESCWebView_Bridge = function() {
    var action, args, handle, parameters;
    args = Array.prototype.slice.call(arguments);
    handle = new XMLHttpRequest();
    action = args.pop();
    parameters = __ESCWebView_Bridge_Arguments_Wrapper(args);
    if (parameters.__ESCWebView_Bridge_ObjectType !== 'string') {
      parameters = JSON.stringify(parameters);
    }
    handle.open('POST', 'ESCWEBVIEWBRIDGE://' + __ESCWebView_UniqueId_Key + '/' + action + '/' + (++__ESCWebViewBridge_SerializeNo_) + '?' + parameters, false);
    handle.setRequestHeader('ESCWebViewBridge_SerializeNo', ++__ESCWebViewBridge_SerializeNo_);
    handle.send(null);
    if (handle.responseText) {
      return handle.responseText;
    }
    return null;
  };

  this.__ESCWebView_Bridge_eval_callback = function(callback, args) {
    if (!(callback = __ESCWebView_Bridge_Function_Wrapper_[callback])) {
      return;
    }
    return callback.apply(null, __ESCWebView_Bridge_Arguments_Analyzer(args));
  };

  this.__ESCWebView_Bridge_delete_callback = function(callback) {
    return delete __ESCWebView_Bridge_Function_Wrapper_[callback];
  };

  String.prototype.__ESCWebView_Bridge_ObjectType = 's';

  Number.prototype.__ESCWebView_Bridge_ObjectType = 'n';

  Boolean.prototype.__ESCWebView_Bridge_ObjectType = 'b';

  Function.prototype.__ESCWebView_Bridge_ObjectType = 'f';

  Date.prototype.__ESCWebView_Bridge_ObjectType = 'd';

  Array.prototype.__ESCWebView_Bridge_ObjectType = 'a';

  __ESCWebView_Bridge_Arguments_Wrapper = function(arg) {
    var item, newArray, newObject, property, propertyValue, type, _i, _len;
    type = arg.__ESCWebView_Bridge_ObjectType;
    if (type === 's') {
      return 's->' + arg;
    }
    if (type === 'n') {
      return 'n->' + arg;
    }
    if (type === 'b') {
      return 'b->' + arg;
    }
    if (type === 'd') {
      return 'd->' + arg;
    }
    if (type === 'f') {
      __ESCWebView_Bridge_Function_Wrapper_[__ESCWebView_Bridge_Function_Wrapper_SerializeNo_] = arg;
      return 'f' + __ESCWebView_Bridge_Function_Wrapper_SerializeNo_++;
    }
    if (type === 'a') {
      newArray = [];
      for (_i = 0, _len = arg.length; _i < _len; _i++) {
        item = arg[_i];
        newArray.push(__ESCWebView_Bridge_Arguments_Wrapper(item));
      }
      return newArray;
    }
    newObject = {};
    for (property in arg) {
      propertyValue = arg[property];
      newObject[property] = __ESCWebView_Bridge_Arguments_Wrapper(propertyValue);
    }
    return newObject;
  };

  __ESCWebView_Bridge_Arguments_Analyzer = function(args) {
    var arg, array, date, object, property, propertyValue, type, value, _i, _len;
    type = '';
    value = {};
    if (args.__ESCWebView_Bridge_ObjectType === 's') {
      type = args.substring(0, 1);
      value = args.substring(3);
    } else if (args.__ESCWebView_Bridge_ObjectType === 'a') {
      type = 'a';
      value = args;
    } else {
      type = 'o';
      value = args;
    }
    if (type === 's') {
      return value;
    }
    if (type === 'n') {
      return value;
    }
    if (type === 'b') {
      return value;
    }
    if (type === 'd') {
      date = new Date();
      date.setTime(value * 1000);
      return date;
    }
    if (type === 'a') {
      array = [];
      for (_i = 0, _len = value.length; _i < _len; _i++) {
        arg = value[_i];
        array.push(__ESCWebView_Bridge_Arguments_Analyzer(arg));
      }
      return array;
    }
    if (type === 'object') {
      object = {};
      for (property in value) {
        propertyValue = value[property];
        object[property] = __ESCWebView_Bridge_Arguments_Analyzer(propertyValue);
      }
      return object;
    }
    return null;
  };

}).call(this);
