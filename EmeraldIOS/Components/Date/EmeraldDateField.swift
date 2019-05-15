//
//  EmeraldDateField.swift
//  EmeraldIOS
//
//  Created by Genesis Sanguino on 5/14/19.
//  Copyright © 2019 Condor Labs. All rights reserved.
//

import UIKit

public protocol EmeraldDateFieldType: EmeraldTextFieldType {
    func set(notifiable: EmeraldDateFieldChangeNotifiable?)
    func set(minimumDate: Date?)
    func getMinimumDate() -> Date?
    func set(maximumDate: Date?)
    func getMaximumDate() -> Date?
    func forbidDatesPreviousThanToday()
    func allowDatesPreviousThanToday()
    func forbidDatesLaterThanToday()
    func allowDatesLaterThanToday()
    func set(dateFormat: String)
    func getDate(from string: String) -> Date?
}

public protocol EmeraldDateFieldTestableType {
    func set(selectedDate: Date)
    func set(day: Int, month: Int, year: Int)
    func set(hour: Int, minute: Int)
}

public class EmeraldDateField: EmeraldTextField, EmeraldDateFieldType, EmeraldDateFieldTestableType {
    
    private var selectedDate: Date?
    private lazy var dateFormatter: DateFormatter = DateFormatter()
    private weak var notifiable: EmeraldDateFieldChangeNotifiable?
    private lazy var toolbar: UIToolbar = UIToolbar()
    private var minimumDate: Date?
    private var maximumDate: Date?
    
    struct InnerConstants {
        static let calendarIcon = "calendar_icon"
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.configureDateField()
        self.addCalendarIcon()
        self.setupToolbar()
        self.setupDefaultDateFormat()
    }
    
    override func validateContent() -> Result<Bool, Error> {
        guard let text = self.getValue(), !text.isEmpty else {
            return .failure(FormFieldError.emptyField)
        }
        
        guard let date = self.selectedDate else {
            return .failure(EmeraldDateFieldError.invalidDateFormat)
        }
        
        if let minimumDate = self.minimumDate {
            guard date >= minimumDate else {
                return .failure(EmeraldDateFieldError.lowerThanMinimumDate)
            }
        }
        
        if let maximumDate = self.maximumDate {
            guard date <= maximumDate else {
                return .failure(EmeraldDateFieldError.greaterThanMaximumDate)
            }
        }
        
        guard let _ = getDate(from: text) else {
            return .failure(EmeraldDateFieldError.invalidDateFormat)
        }
        
        return .success(true)
    }
    
    public override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        if let validatedText = self.text,
            let dateValue = getDate(from: validatedText) {
            self.set(selectedDate: dateValue)
        }
        self.resignFirstResponder()
        notifiable?.onDoneButtonPressed(from: self)
    }
    
    public func set(selectedDate: Date) {
        self.selectedDate = selectedDate
        let formattedDate = dateFormatter.string(from: selectedDate)
        self.text = formattedDate
        notifiable?.onSelected(dateString: formattedDate, date: selectedDate, from: self)
    }
    
    public func set(day: Int, month: Int, year: Int) {
        if let date = getDateFrom(day: day, month: month, year: year) {
            self.set(selectedDate: date)
        }
    }
    
    public func set(hour: Int, minute: Int) {
        if let date = getDateFrom(hour: hour, minute: minute) {
            self.set(selectedDate: date)
        }
    }
    
    public func set(notifiable: EmeraldDateFieldChangeNotifiable?) {
        self.notifiable = notifiable
    }
    
    public func set(dateFormat: String) {
        self.dateFormatter.dateFormat = dateFormat
    }
    
    public func getDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.defaultFormat
        dateFormatter.locale = Locale(identifier: Constants.DateFormat.defaultLocale)
        return dateFormatter.date(from: string)
    }
    
    public func set(minimumDate: Date?) {
        self.minimumDate = minimumDate
    }
    
    public func getMinimumDate() -> Date? {
        return self.minimumDate
    }
    
    public func set(maximumDate: Date?) {
        self.maximumDate = maximumDate
    }
    
    public func getMaximumDate() -> Date? {
        return self.maximumDate
    }
    
    public func forbidDatesPreviousThanToday() {
        self.minimumDate = Date()
    }
    
    public func allowDatesPreviousThanToday() {
        self.minimumDate = nil
    }
    
    public func forbidDatesLaterThanToday() {
        self.maximumDate = Date()
    }
    
    public func allowDatesLaterThanToday() {
        self.maximumDate = nil
    }
    
    private func setupToolbar() {
        self.toolbar.barStyle = UIBarStyle.default
        self.toolbar.isTranslucent = true
        self.toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonPressed))
        
        self.toolbar.setItems([flexibleSpace, doneButton], animated: false)
        self.toolbar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolbar
    }
    
    private func configureDateField() {
        self.set(format: .date)
    }
    
    private func addCalendarIcon() {
        let calendarIcon = UIImage(named: InnerConstants.calendarIcon,
                                   in: Bundle(for: ClassBundle.self),
                                   compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        guard let image = calendarIcon else {
            return
        }
        
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0,
                                              left: -18,
                                              bottom: 0,
                                              right: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = EmeraldTheme.primaryColor
        button.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
        button.isUserInteractionEnabled = true
        button.becomeFirstResponder()
        
        guard let rightView = rightView else {
            return
        }
        
        button
            .heightAnchor
            .constraint(equalToConstant: 20)
            .isActive = true
        
        button
            .widthAnchor
            .constraint(equalToConstant: 20)
            .isActive = true
        
        button
            .centerYAnchor
            .constraint(equalTo: rightView.centerYAnchor)
            .isActive = true
    }
    
    private func setupDefaultDateFormat() {
        dateFormatter.locale = Locale(identifier: Constants.DateFormat.defaultLocale)
        dateFormatter.timeZone = TimeZone(abbreviation: Constants.DateFormat.defaultTimeZone)
        dateFormatter.dateFormat = Constants.DateFormat.defaultFormat
    }
    
    private func getDateFrom(
        day: Int? = nil,
        month: Int? = nil,
        year: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil) -> Date? {
        
        var dateComponents = DateComponents()
        
        if let day = day {
            dateComponents.day = day
        }
        
        if let month = month {
            dateComponents.month = month
        }
        
        if let year = year {
            dateComponents.year = year
        }
        
        if let hour = hour {
            dateComponents.hour = hour
        }
        
        if let minute = minute {
            dateComponents.minute = minute
        }
        
        return Calendar.current.date(from: dateComponents)
    }
    
    @objc private func openDatePicker() {
        self.textFieldDidBeginEditing(self)
        let datePicker = EmeraldDatePickerAlert()
        
        if let minimumDate = self.minimumDate {
            datePicker.set(minimumDate: minimumDate)
        }
        
        if let maximumDate = self.maximumDate {
            datePicker.set(maximumDate: maximumDate)
        }
        
        if let currentDate = self.getDate(from: self.text ?? Constants.Values.empty) {
            datePicker.set(currentDateValue: currentDate)
        }
        
        datePicker.show(self.placeHolder ?? Constants.Values.empty) { [unowned self] date in
            guard let date = date else {
                self.textFieldDidEndEditing(self)
                return
            }
            self.set(selectedDate: date)
            self.textFieldDidEndEditing(self)
        }
    }
    
    @objc private func onDoneButtonPressed() {
        self.endEditing(true)
        notifiable?.onDoneButtonPressed(from: self)
    }
}