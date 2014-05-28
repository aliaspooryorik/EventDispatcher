EventDispatcher
===============

A simple EventDispatcher to support EDP in CFML. Allows you to de-couple and reduce dependancies.

Version 0.1 Alpha

## Requirements

Railo3+ / CF9+

## Dependancies

None, but using a beanfactory that supports getBean is recommended.

## Usage

You can register custom events and listeners when your application starts up, or you can add listeners on the fly.
Listeners will be called in the order that they are specified.

### Instantiation

Instantiation as a standalone.

```
// create the EventDispatcher which has a dependancy on a beanFactory
var EventDispatcher = new libraries.EventDispatcher.EventDispatcher();

````

Instantiation when using a BeanFactory (recommended)

```
// create the EventDispatcher which has a dependancy on a beanFactory
var EventDispatcher = new libraries.EventDispatcher.EventDispatcher(BeanFactory);

// optional add the Instantiated EventDispatcher instance to your bean factory so you can inject it via DI
Beanfactory.addBean('EventDispatcher', EventDispatcher);
````

### Adding Event Listeners

#### Signature:

```
addEventListener(required string type, required any listener) : void
```

You can create any event name and specify one or more listeners. For example if I wanted to fire a 'OrderPlaced' event
which would notify my MailService I can do this:

```
// Notify the MailService when the 'OrderPlaced' event occurs
MailService = new MailService();
EventDispatcher.addEventListener('OrderPlaced', MailService);
```

If you are using a beanfactory then you can also add listeners by name (which is then loaded from the BeanFactory).
Note that you will probably want to inject the EventDispatcher into your model or controller via DI.


```
// Notify the MailService when the 'OrderPlaced' event occurs
EventDispatcher.addEventListener('OrderPlaced', 'MailService');
```


### Triggering events

To trigger the above event I would do:

```
// trigger the OrderPlaced event
EventDispatcher.dispatchEvent('OrderPlaced');
// trigger the OrderPlaced event with option message
EventDispatcher.dispatchEvent('OrderPlaced', {orderid=123});
// I can pass any datatype in as the second argument
EventDispatcher.dispatchEvent('OrderPlaced', Order);
```

The above example will call the `OrderPlaced` method of the `MailService` object.


As your application grows you will find that you want to trigger events in multiple listeners. For example:

```
// pass in an array of bean names in order you want them to fire
EventDispatcher.addEventListener('OrderPlaced', 'MailService');
EventDispatcher.addEventListener('OrderPlaced', 'StockManager');
EventDispatcher.addEventListener('OrderPlaced', 'CommissionService');
```

Each of the listeners will be notified in turn. You can also write the above as:


```
// pass in an array of bean names in order you want them to fire
EventDispatcher.addEventListener('OrderPlaced', ['MailService','StockManager','CommissionService']);
```

You can also pass in a mixture of beans by name or as an object. For example:

```
// pass in an array of bean names in order you want them to fire
StockManager = new StockManager();
EventDispatcher.addEventListener('OrderPlaced', ['MailService', StockManager]);

```

As mentioned above, listeners are called in sequential order. If the called method returns false, then the
loop will break at that point and subsequent listeners in the queue will not be notified.


#### Extension points

A `getEventMap` method is also provided as an extension point.

```
getEventMap([string type]) : struct;
```


#### Removing Event Listeners

You can remove an eventListener by calling the `removeEventListener` method.

```
// add listener by name
EventDispatcher.addEventListener('OrderPlaced', 'MailService');

// remove listener by name
EventDispatcher.removeEventListener('OrderPlaced', 'MailService');


// add listener as object
MailService = new MailService();
EventDispatcher.addEventListener('OrderPlaced', MailService);

// remove listener as object
EventDispatcher.removeEventListener('OrderPlaced', MailService);

```

