//
//  UIImagePlusPDFTests.swift
//  UIImagePlusPDFTests
//
//  Created by Dima Mishchenko on 16.05.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import XCTest
@testable import UIImagePlusPDF

class UIImagePlusPDFTests: XCTestCase {
    
  func testImageWithName() {
    // given
    let imageName = "cat"
    let size: CGFloat = 69
    
    // when
    let imageDefault = UIImage.pdfImage(with: imageName)
    let imageWithWidth = UIImage.pdfImage(with: imageName, width: size)
    let imageWithHeight = UIImage.pdfImage(with: imageName, height: size)
    let imageWithSize = UIImage.pdfImage(with: imageName, size: CGSize(width: size, height: size))
    let imageWithPDFSize = UIImage.pdfImage(with: imageName, size: .default)
    
    // then
    XCTAssertNotNil(imageDefault)
    
    XCTAssertNotNil(imageWithWidth)
    XCTAssertEqual(imageWithWidth?.size.width, size)
    
    XCTAssertNotNil(imageWithHeight)
    XCTAssertEqual(imageWithWidth?.size.height, size)
    
    XCTAssertNotNil(imageWithSize)
    XCTAssertEqual(imageWithWidth?.size, CGSize(width: size, height: size))
    
    XCTAssertNotNil(imageWithPDFSize)
  }
  
  func testImageWithURL() {
    // given
    guard let imageURL = Bundle.main.url(forResource: "cat", withExtension: "pdf") else { XCTFail(); return }
    let size: CGFloat = 69
    
    // when
    let imageDefault = UIImage.pdfImage(with: imageURL)
    let imageWithWidth = UIImage.pdfImage(with: imageURL, width: size)
    let imageWithHeight = UIImage.pdfImage(with: imageURL, height: size)
    let imageWithSize = UIImage.pdfImage(with: imageURL, size: CGSize(width: size, height: size))
    let imageWithPDFSize = UIImage.pdfImage(with: imageURL, size: .default)
    
    // then
    XCTAssertNotNil(imageDefault)
    
    XCTAssertNotNil(imageWithWidth)
    XCTAssertEqual(imageWithWidth?.size.width, size)
    
    XCTAssertNotNil(imageWithHeight)
    XCTAssertEqual(imageWithWidth?.size.height, size)
    
    XCTAssertNotNil(imageWithSize)
    XCTAssertEqual(imageWithWidth?.size, CGSize(width: size, height: size))
    
    XCTAssertNotNil(imageWithPDFSize)
  }
  
  func testImageWithZeroSize() {
    // given
    let imageName = "cat"
    
    // when
    let image = UIImage.pdfImage(with: imageName, size: .zero)
    
    // then
    XCTAssertNil(image)
  }
}
