import 'package:baseflutter/network/model/test_model_entity.dart';

testModelEntityFromJson(TestModelEntity data, Map<String, dynamic> json) {
	if (json['data'] != null) {
		data.data = json['data']?.toString();
	}
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	return data;
}

Map<String, dynamic> testModelEntityToJson(TestModelEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['data'] = entity.data;
	data['code'] = entity.code;
	return data;
}