import 'package:baseflutter/generated/json/base/json_convert_content.dart';

class ArticleTestEntity with JsonConvert<ArticleTestEntity> {
	int code;
	ArticleTestData data;
}

class ArticleTestData with JsonConvert<ArticleTestData> {
	String preview;
	bool wished;
	ArticleTestDataFirstCategory firstCategory;
	String description;
	String video;
	String title;
	String explanation;
	int price;
	String videoName;
	int popularity;
	bool trialReading;
	String paperBookLink;
	int id;
	String audio;
	int auditionRatio;
	String image;
	String editor;
	String structureImage;
	bool dailyFreeArticle;
	String finished;
	int authorId;
	int version;
	bool purchased;
	String authorName;
	String anchor;
	String videoImage;
	bool behaviour;
}

class ArticleTestDataFirstCategory with JsonConvert<ArticleTestDataFirstCategory> {
	int id;
	int position;
	bool enabled;
	int popularity;
}
