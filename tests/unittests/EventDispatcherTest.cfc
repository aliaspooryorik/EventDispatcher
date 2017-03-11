component extends="testbox.system.BaseSpec" {

	void function beforeTests() {
		variables.mock.beanfactory = createStub().$("hasBean");
	}

	void function setup(currentMethod) {
		variables.CUT = new _.EventDispatcher();
		variables.Fixture = createStub();
	}

	// --- tests ---- //


	void function test_addEventListener_adds_listener_by_name() {
		local.event = 'EverythingIsAwesome';
		local.listener = 'Fixture';
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener]);
	}

	void function test_addEventListener_adds_listener_by_object() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener]);
	}

	void function test_addEventListener_adds_listeners_as_array() {
		local.event = 'EverythingIsAwesome';
		local.listeners = [variables.fixture,'Fixture'];
		variables.CUT.addEventListener(local.event, local.listeners);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, local.listeners);
	}

	void function test_addEventListener_adds_listeners_to_internal_array() {
		local.event = 'EverythingIsAwesome';
		local.listeners = [variables.fixture,'Fixture'];
		variables.CUT.addEventListener(local.event, local.listeners[1]);
		variables.CUT.addEventListener(local.event, local.listeners[2]);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, local.listeners);
	}

	void function test_removeEventListener_removes_listener_by_name() {
		local.event = 'EverythingIsAwesome';
		local.listener = 'Fixture';
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener], "should have one listener");
		variables.CUT.removeEventListener(local.event, local.listener);
		$assert.isEqual(local.actual, [], "should be an empty array");
	}

	void function test_removeEventListener_does_not_remove_listener_for_different_event_by_name() {
		local.event = 'EverythingIsAwesome';
		local.listener = 'Fixture';
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener], "should have one listener");
		variables.CUT.removeEventListener('DifferentEventName', local.listener);
		$assert.isEqual(local.actual, [local.listener], "should not have removed the listener for a different event");
	}


	void function test_removeEventListener_removes_listener_by_object() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener], "should have one listener");
		variables.CUT.removeEventListener(local.event, local.listener);
		$assert.isEqual(local.actual, [], "should be an empty array");
	}

	void function test_removeEventListener_does_not_remove_listener_for_different_event_by_object() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		variables.CUT.addEventListener(local.event, local.listener);
		local.actual = variables.CUT.getEventMap(local.event);
		$assert.isEqual(local.actual, [local.listener], "should have one listener");
		variables.CUT.removeEventListener('DifferentEventName', local.listener);
		$assert.isEqual(local.actual, [local.listener], "should not have removed the listener for a different event");
	}

	void function test_dispatchEvent_calls_the_listener_method_with_no_message() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		variables.CUT.addEventListener(local.event, local.listener);
		variables.Fixture.$("everythingIsAwesome");
		variables.CUT.dispatchEvent(local.event);
		$assert.isTrue(variables.Fixture.$once(local.event));
	}

	void function test_dispatchEvent_calls_the_listener_method_with_simple_message() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		local.message = 'MyMessage';
		variables.CUT.addEventListener(local.event, local.listener);
		variables.Fixture.$("everythingIsAwesome");
		variables.CUT.dispatchEvent(local.event, local.message);
		$assert.isTrue(variables.Fixture.$once(local.event));
		$assert.isEqual(local.message, variables.Fixture.$callLog().everythingIsAwesome[1].1);
	}

	void function test_dispatchEvent_calls_the_listener_method_with_complex_message() {
		local.event = 'EverythingIsAwesome';
		local.listener = variables.fixture;
		local.message = {MyMessage=[1,2,3,4]};
		variables.CUT.addEventListener(local.event, local.listener);
		variables.Fixture.$("everythingIsAwesome");
		variables.CUT.dispatchEvent(local.event, local.message);
		$assert.isTrue(variables.Fixture.$once(local.event));
		$assert.isEqual(local.message, variables.Fixture.$callLog().everythingIsAwesome[1].1);
	}

	void function test_dispatchEvent_calls_each_listener() {
		local.event = 'EverythingIsAwesome';
		local.listeners = [variables.fixture,variables.fixture,variables.fixture];
		variables.CUT.addEventListener(local.event, local.listeners);
		variables.Fixture.$("everythingIsAwesome");
		variables.CUT.dispatchEvent(local.event);
		$assert.isEqual(3, variables.Fixture.$count(local.event));
	}

	void function test_dispatchEvent_breaks_loop_when_called_listener_returns_false() {
		local.event = 'EverythingIsAwesome';
		local.listeners = [variables.fixture,variables.fixture,variables.fixture,variables.fixture];
		variables.CUT.addEventListener(local.event, local.listeners);
		variables.Fixture.$("everythingIsAwesome").$results(true, false);
		variables.CUT.dispatchEvent(local.event);
		$assert.isEqual(2, variables.Fixture.$count(local.event));
	}

	void function test_dispatchEvent_calls_beanfactory_to_get_named_beans() {
		local.listener = 'MyBean';
		local.event = 'EverythingIsAwesome';
		local.BeanFactory = createStub().$("getBean").$args(local.listener).$results(variables.Fixture);
		variables.CUT.setBeanFactory(local.BeanFactory);
		variables.CUT.addEventListener(local.event, local.listener);
		variables.Fixture.$("everythingIsAwesome");
		variables.CUT.dispatchEvent(local.event);
		$assert.isTrue(local.BeanFactory.$once('getBean'));
		$assert.isEqual(1, variables.Fixture.$count(local.event));
	}

}
