//
//  FundsRequestQRDisplayViewController.swift
//  MyMonero
//
//  Created by Paul Shapiro on 8/16/17.
//  Copyright (c) 2014-2018, MyMonero.com
//
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of
//	conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list
//	of conditions and the following disclaimer in the documentation and/or other
//	materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its contributors may be
//	used to endorse or promote products derived from this software without specific
//	prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
//  THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
import UIKit

class FundsRequestQRDisplayViewController: UICommonComponents.ScrollableValidatingInfoViewController
{
	//
	// Constants
	
	//
	// Properties
	var fundsRequest: FundsRequest
	var presentedAsModal: Bool = false
	//
	var informationalLabel: UICommonComponents.FormAccessoryMessageLabel!
	var imageView: UIImageView!
	//
	// Lifecycle - Init
	init(fundsRequest: FundsRequest, presentedAsModal: Bool = false)
	{
		self.fundsRequest = fundsRequest
		self.presentedAsModal = presentedAsModal
		super.init()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func setup()
	{
		super.setup()
		self.view.backgroundColor = .contentBackgroundColor
		do {
			let hasAmount = self.fundsRequest.amount != nil
			let to_address = self.fundsRequest.to_address!
			var text: String
			if hasAmount {
				let xmrSymbol = CcyConversionRates.Currency.XMR.symbol
				let ccySymbol = self.fundsRequest.amountCurrency ?? xmrSymbol // handles nil default
				if ccySymbol == xmrSymbol {
					text = String(
						format: NSLocalizedString("Scan this code to send %@ %@ to %@.", comment: ""),
						self.fundsRequest.amount!,
						CcyConversionRates.Currency.XMR.symbol,
						to_address
					)
				} else {
					text = String(
						format: NSLocalizedString("Scan this code to send %@ %@ in Monero to %@.", comment: ""),
						self.fundsRequest.amount!,
						self.fundsRequest.amountCurrency!, // actually the symbol
						to_address
					)
				}
			} else {
				text = String(
					format: NSLocalizedString("Scan this code to send Monero to %@.", comment: ""),
					to_address
				)
			}
			let view = UICommonComponents.FormAccessoryMessageLabel(
				text: text
			)
			view.textAlignment = .center
			view.numberOfLines = 0
			view.lineBreakMode = .byTruncatingTail
			self.informationalLabel = view
			self.scrollView.addSubview(view)
		}
		do {
			let image = QRCodeImages.new_qrCode_UIImage( // generating a new image here - is this performant enough?
				fromCGImage: self.fundsRequest.qrCode_cgImage,
				withQRSize: .large
			)
			let view = UIImageView(image: image)
			view.image = image
			self.imageView = view
			self.scrollView.addSubview(self.imageView)
		}
		do {
			self.navigationItem.title = NSLocalizedString("Scan Code to Pay", comment: "")
			if self.fundsRequest.is_displaying_local_wallet != true || self.presentedAsModal {
				self.navigationItem.leftBarButtonItem = UICommonComponents.NavigationBarButtonItem(
					type: .go,
					tapped_fn:
					{ [unowned self] in
						self.navigationController!.dismiss(
							animated: true,
							completion: nil
						)
					},
					title_orNilForDefault: NSLocalizedString("Done", comment: "")
				)
			} else {
				self.navigationItem.leftBarButtonItem = UICommonComponents.NavigationBarButtonItem(
					type: .back,
					tapped_fn:
					{ [unowned self] in
						self.navigationController?.popViewController(animated: true)
					}
				)
			}
		}
		do {
			let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
			recognizer.direction = .down
			self.scrollView.addGestureRecognizer(recognizer)
		}
		do {
			let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
			self.scrollView.addGestureRecognizer(recognizer)
		}
	}
	//
	// Lifecycle - Teardown
	
	//
	// Accessors - Overrides
	override func new_wantsInlineMessageViewForValidationMessages() -> Bool
	{
		return false
	}
	//
	// Imperatives - Overrides - Layout
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		let top_yOffset: CGFloat = 48
		do { // label
			let min_marginX: CGFloat = 16
			let w = min(
				self.scrollView/*not self.view*/.frame.size.width - 2*min_marginX,
				400
			)
			self.informationalLabel.frame = CGRect(
				x: (self.scrollView/*not self.view*/.frame.size.width - w)/2,
				y: top_yOffset,
				width: w,
				height: 18
			).integral
		}
		let qrSize: QRCodeImages.QRSize = .large
		self.imageView.frame = CGRect(
			x: (self.scrollView/*not self.view*/.frame.size.width - qrSize.width)/2,
			y: self.informationalLabel.frame.origin.y + self.informationalLabel.frame.size.height + 32,
			width: qrSize.width,
			height: qrSize.height
		).integral
		//
		self.scrollableContentSizeDidChange(withBottomView: self.imageView, bottomPadding: 24)
	}
	//
	// Delegation - Interactions
	@objc func swipedDown()
	{
		self.navigationController!.dismiss(animated: true, completion: nil)
	}
	@objc func tapped()
	{
		self.navigationController!.dismiss(animated: true, completion: nil)
	}
}
