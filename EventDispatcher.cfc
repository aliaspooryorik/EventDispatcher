component accessors="true" {

	property name="BeanFactory" getter="false"; // bean factory aware

	any function init(BeanFactory) {
		variables.events = {};
		if (structkeyexists(arguments,"BeanFactory")) {
			variables.BeanFactory = arguments.BeanFactory;
		}
		return this;
	}

	/**
	  * add an listener to a specific event.
	  * note that the listener can be an array, a string or an object
	  **/
	void function addEventListener(required string type, required any listener) {
		arguments.type = ucase(arguments.type);
		if (hasListeners(arguments.type)) {
			if (isarray(arguments.listener)) {
				variables.events[arguments.type].addAll(arguments.listener);
			} else {
				arrayappend(variables.events[arguments.type], arguments.listener);
			}
		} else {
			if (isarray(arguments.listener)) {
				variables.events[arguments.type] = arguments.listener;
			} else {
				variables.events[arguments.type] = [arguments.listener];
			}
		}
	}

	void function dispatchEvent(required string type, any message) {
		arguments.type = ucase(arguments.type);
		if (hasListeners(arguments.type)) {
			for (local.listener in variables.events[arguments.type]) {
				if (issimplevalue(local.listener)) {
					// get the object by name
					local.listener = variables.BeanFactory.getBean(local.listener);
				}
				try {
					if (structkeyexists(arguments,"message")) {
						local.continue = evaluate("local.listener.#arguments.type#(arguments.message)");
					} else {
						local.continue = evaluate("local.listener.#arguments.type#()");
					}
				} catch (any local.e) {
					throw(type="EventDispatcher.dispatchEvent", message=local.e.message, detail=local.e.detail);
				}
				if (!isnull(local.continue) && !local.continue) {
					// method returned false so exit
					break;
				}
			}
		}
	}

	void function removeEventListener(required string type, required any listener) {
		arguments.type = ucase(arguments.type);
		if (hasListeners(arguments.type)) {
			local.index = arrayfind(variables.events[arguments.type], arguments.listener);
			if (local.index) {
				arraydeleteat(variables.events[arguments.type], local.index);
			}
		}
	}

	struct function getEventMap(string type) {
		if (structkeyexists(arguments, "type")) {
			return variables.events[arguments.type];
		}
		return variables.events;
	}

	// --- private --- //
	private boolean function hasListeners(required string type) {
		return structkeyexists(variables.events, arguments.type);
	}
}
