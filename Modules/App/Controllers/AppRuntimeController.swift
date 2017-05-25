//
//  RuntimeController.swift
//  MyMonero
//
//  Created by Paul Shapiro on 5/5/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//
//
import UIKit
//
class AppRuntimeController
{
	var windowController: WindowController!
	var walletsListController: WalletsListController!
	//
	init(windowController: WindowController)
	{
		self.windowController = windowController
		setup()
	}
	func setup()
	{
		self.walletsListController = WalletsListController()
		DispatchQueue.main.async
		{
			
			
			let seedAsMnemonicString = "foxes selfish humid nexus juvenile dodge pepper ember biscuit elapse jazz vibrate biscuit"
			self.walletsListController.GivenBooted_ObtainPW_AddExtantWalletWith_MnemonicString(
				walletLabel: "m'wallet",
				swatchColor: .salmon,
				mnemonicString: seedAsMnemonicString,
				{ (err_str, wallet, wasWalletAlreadyInserted) in
					if err_str != nil {
						NSLog("err_str: \(err_str.debugDescription)")
						return
					}
					NSLog("wallet \(wallet.debugDescription)")
					NSLog("wasWalletAlreadyInserted \(wasWalletAlreadyInserted.debugDescription)")
				}
			)
			
			
			// Testing creating a new wallet:
//			self.walletsListController.CreateNewWallet_NoBootNoListAdd()
//			{ (err_str, walletInstance) in
//				if err_str != nil {
//					NSLog("err \(err_str!)")
//					return
//				}
//				NSLog("Created new wallet instance but not inserted or booted yet: \(walletInstance!)")
//				// …… gather info from user……
//				//
//				self.walletsListController.GivenBooted_ObtainPW_AddNewlyGeneratedWallet(
//					walletInstance: walletInstance!,
//					walletLabel: "Checking",
//					swatchColor: .salmon,
//					{ (err_str, addedWallet) in
//						if err_str != nil {
//							NSLog("err \(err_str!)")
//							return
//						}
//						NSLog("added/booted/logged in wallet \(addedWallet.debugDescription)")
//					}
//				)
//			}
		}
	}
}