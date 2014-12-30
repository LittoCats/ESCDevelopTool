@__ESCWebViewBridge_SerializeNo_ = 0
@__ESCWebView_Bridge_Function_Wrapper_SerializeNo_ = 0
@__ESCWebView_Bridge_Function_Wrapper_ = {}

@__ESCWebView_registeNativeCallback_ = (name)->
	return null if name.length == 0
	@[name] = ->
		args = Array::slice.call arguments
		args.push name
		__ESCWebView_Bridge.apply null,args

# js 调用 native 的关键函数
__ESCWebView_Bridge = ->
	args = Array::slice.call arguments
	handle = new XMLHttpRequest()
	
	action = args.pop()
	parameters = __ESCWebView_Bridge_Arguments_Wrapper args
	parameters = JSON.stringify parameters if parameters.__ESCWebView_Bridge_ObjectType != 'string' 
	handle.open 'POST','ESCWEBVIEWBRIDGE://'+__ESCWebView_UniqueId_Key+'/'+action+'/'+(++__ESCWebViewBridge_SerializeNo_)+'?'+parameters,false
	handle.setRequestHeader 'ESCWebViewBridge_SerializeNo',++__ESCWebViewBridge_SerializeNo_
	handle.send null
	return handle.responseText if handle.responseText
	null

# 管理由 js 传到 native 的 function
@__ESCWebView_Bridge_eval_callback = (callback, args)->
	return if !callback = __ESCWebView_Bridge_Function_Wrapper_[callback]
	callback.apply null,__ESCWebView_Bridge_Arguments_Analyzer args

@__ESCWebView_Bridge_delete_callback = (callback)->
	delete __ESCWebView_Bridge_Function_Wrapper_[callback]

# 数据类型转换
String::__ESCWebView_Bridge_ObjectType = 's'
Number::__ESCWebView_Bridge_ObjectType = 'n'
Boolean::__ESCWebView_Bridge_ObjectType = 'b'
Function::__ESCWebView_Bridge_ObjectType = 'f'
Date::__ESCWebView_Bridge_ObjectType = 'd'
Array::__ESCWebView_Bridge_ObjectType = 'a'

__ESCWebView_Bridge_Arguments_Wrapper = (arg)->
	type = arg.__ESCWebView_Bridge_ObjectType
	
	return 's->'+arg if type is 's'
	return 'n->'+arg if type is 'n' 
	return 'b->'+arg if type is 'b' 
	return 'd->'+arg if type is 'd' 
	if type is 'f'
		__ESCWebView_Bridge_Function_Wrapper_[__ESCWebView_Bridge_Function_Wrapper_SerializeNo_] = arg
		return 'f'+__ESCWebView_Bridge_Function_Wrapper_SerializeNo_++
	if type is 'a'
		newArray = []
		newArray.push __ESCWebView_Bridge_Arguments_Wrapper item for item in arg
		return newArray
	# object
	newObject = {}
	newObject[property] = __ESCWebView_Bridge_Arguments_Wrapper propertyValue for property,propertyValue of arg
	return newObject

__ESCWebView_Bridge_Arguments_Analyzer = (args)->
	type = ''
	value = {}
	if args.__ESCWebView_Bridge_ObjectType is 's'
		type = args.substring 0,1
		value = args.substring 3
	else if args.__ESCWebView_Bridge_ObjectType is 'a'
		type = 'a'
		value = args
	else
		type = 'o'
		value = args

	return value if type is 's' 
	return value if type is 'n' 
	return value if type is 'b' 
	if type is 'd' then date = new Date(); date.setTime value*1000; return date
	if type is 'a' 
		array = []
		array.push __ESCWebView_Bridge_Arguments_Analyzer arg for arg in value
		return array

	if type is 'object'
		object = {}
		object[property] = __ESCWebView_Bridge_Arguments_Analyzer propertyValue for property,propertyValue of value
		return object
	return null