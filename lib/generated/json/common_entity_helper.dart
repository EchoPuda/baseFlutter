import 'package:baseflutter/network/model/common_entity.dart';

commonEntityFromJson(CommonEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code']?.toInt();
	}
	return data;
}

Map<String, dynamic> commonEntityToJson(CommonEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	return data;
}