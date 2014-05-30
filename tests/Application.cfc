component {

	this.name = "eventdispatcher_tests";

	this.mappings['/tests'] = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings['/_'] = expandpath("../../");

}
