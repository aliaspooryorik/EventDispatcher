component {

	this.name = "eventdispatcher_tests";

	this.mappings['/tests'] = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings['/testbox'] = "/home/aliaspooryorik/projects/cfml/EventDispatcher/tests/testbox/";
	this.mappings['/_'] = expandpath("../../");

	function onRequestStart() {
		// writeDump(this.mappings);
		// writeDump(new testbox.system.TestBox());
		// abort;
		// var meh = new testbox.system.testing.TestBox();
	}

}
