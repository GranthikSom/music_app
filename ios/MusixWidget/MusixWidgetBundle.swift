//
//  MusixWidgetBundle.swift
//  MusixWidget
//
//  Created by Granthik Som on 14/03/26.
//

import WidgetKit
import SwiftUI

@main
struct MusixWidgetBundle: WidgetBundle {
    var body: some Widget {
        MusixWidget()
        MusixWidgetControl()
        MusixWidgetLiveActivity()
    }
}
