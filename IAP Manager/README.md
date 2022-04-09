# IAP Manager
This simple module helps you handle in-app purchases and restorations. If your game only has a few consumable in-app purchases and **one** restorable item, then your game is capable of using this module. It does not handle subscriptions. Before you get started, you need to create one or more consumable or non-consumable in-app purchases on App Store Connect. There are already many online tutorials on this topic, so I will skip this part. After that, in your game's Xcode project, include the module file to your project. Then, declare a global variable of type **IAPManager**:
```
var manager: IAPManager!
```
And when the game is loading, access the list of products from the App Store and construct the **IAPManager** object:
```
// replace the ??? with the Product IDs of the in-app purchases:
manager = IAPManager(products: [
    "???",
    "???"
])
```
And when the player wants to purchase an item, call the **purchase** method:
```
// replace the ??? with the Product ID of the item being purchased:
manager.purchase(product: "???")
```
When the player wants to restore the non-consumable item, call the **restore** method:
```
// restore the only non-consumable of your game:
manager.restore()
```
Finally, we need to handle transaction success or failure. Initially, I implemented completion handlers for the **purchase** and **restore** functions. However, since the completion handlers will be called on another thread when the transaction completes, it is not thread-safe, and one should avoid implementing the game's logic inside the completion handlers. Therefore, I used the most straightforward approach:
```
if let result = manager.check() {
    if(result == "failed") {
        // the transaction failed
        // return to the shop menu and show a message
    }else if(result == "???") {
        // the result matches one of the Product IDs
        // the transaction is successful
        // show a message update the game's data
    }
}
```
You should implement the above code in the game's update loop, for example, in the **updateAtTime** function, one of the renderer functions of the **SCNSceneRendererDelegate** protocol. The **check** method of the **IAPManager** returns the Product ID of the purchased item if the item is successfully purchased or restored. It returns the "failed" string if the transaction failed or the user canceled the process. In all other cases, it returns nil.

Note that if you look at the top few lines of the module file, you will find:
```
let IAPDebugAlwaysSucceed: Bool = false
let IAPDebugAlwaysFail: Bool = false
```
If your tester's account has already purchased the in-app purchase and you want to test the case where the transaction fails explicitly, you can set the value of **IAPDebugAlwaysFail** to true. And to make the transactions always succeed, set **IAPDebugAlwaysSucceed** to true. Obviously, forgetting to change these variables back to false before releasing your game is catastrophic for you, but fantastic for your players.
