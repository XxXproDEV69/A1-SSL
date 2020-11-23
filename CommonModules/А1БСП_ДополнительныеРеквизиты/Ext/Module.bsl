﻿#Если НЕ Клиент Тогда
	
	// Возвращает элемент формы, соответствующий переданному имени доп. реквизита.
	// Если элемент формы отсутствует, возвращает Неопределено.
	//
	// Параметры:
	//  Форма						 - ФормаКлиентскогоПриложения - 
	//  ИмяДополнительногоРеквизита	 - Строка - 
	// 
	// Возвращаемое значение:
	//   - ЭлементФормы,Неопределено
	//
	Функция ЭлементФормы(Форма, ИмяДополнительногоРеквизита) Экспорт 
		ИмяЭлементаФормы = ИмяЭлементаФормы(Форма, ИмяДополнительногоРеквизита);
		Если ИмяЭлементаФормы = Неопределено Тогда Возврат Неопределено; КонецЕсли;
		Возврат Форма.Элементы[ИмяЭлементаФормы];	
	КонецФункции
	
	// Возвращает имя элемента формы, соответствующего переданному имени доп. реквизита.
	//
	// Параметры:
	//  Форма						 - ФормаКлиентскогоПриложения - 
	//  ИмяДополнительногоРеквизита	 - Строка - 
	// 
	// Возвращаемое значение:
	//   - ЭлементФормы,Неопределено
	//
	Функция ИмяЭлементаФормы(Форма, ИмяДополнительногоРеквизита) Экспорт
		ОписаниеДопРеквизитов = Форма.Свойства_ОписаниеДополнительныхРеквизитов;
		Строки = ОписаниеДопРеквизитов.НайтиСтроки(А1Э_Структуры.Создать(
		"Свойство", А1Э_ДопРеквизиты.Свойство(ИмяДополнительногоРеквизита),
		));
		Если Строки.Количество() = 0 Тогда Возврат Неопределено; КонецЕсли;
		Возврат Строки[0].ИмяРеквизитаЗначение;	
	КонецФункции 
	
#КонецЕсли

#Область Механизм

Функция НастройкиМеханизма() Экспорт
	Настройки = А1Э_Механизмы.НовыйНастройкиМеханизма();
	
	Настройки.Обработчики.Вставить("А1Э_ПриПоискеОшибок", Истина);
	Настройки.Обработчики.Вставить("А1Э_ПриИсправленииОшибок", Истина);
	
	Настройки.Обработчики.Вставить("ФормаЭлементаПриСозданииНаСервере", Истина);
	Настройки.Обработчики.Вставить("ФормаПриЧтенииНаСервере", Истина);
	Настройки.Обработчики.Вставить("ФормаОбработкаЗаполненияНаСервере", Истина);
	Настройки.Обработчики.Вставить("ФормаПередЗаписьюНаСервере", Истина);
	
	Настройки.Обработчики.Вставить("ФормаПриОткрытии", Истина);
	Настройки.Обработчики.Вставить("ФормаОбработкаОповещения", Истина);
	
	Возврат Настройки;
КонецФункции

#Если НЕ Клиент Тогда
	
	Функция А1Э_ПриПоискеОшибок(Ошибки) Экспорт
		ТаблицаПрефиксов = ТаблицаОбъектовИПрефиксов();
		
		Префиксы = А1Э_ТаблицыЗначений.РазбитьВТаблицыПоКолонке(ТаблицаПрефиксов, "Префикс");
		Реквизиты = Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.Реквизиты;
		ПрефиксыБезРеквизита = Новый Массив;
		Для Каждого Пара Из Префиксы Цикл
			Префикс = Пара.Ключ;
			Если Реквизиты.Найти(Префикс + "_Владелец") = Неопределено Тогда
				А1Э_Механизмы.ДобавитьОписаниеОшибки(Ошибки, "ОтсутствуетРеквизит", , , "Отсутствует реквизит справочника <НаборыДополнительныхРеквизитовИСведений>", , 
				А1Э_Структуры.Создать(
				"Префикс", Префикс,
				));
				ПрефиксыБезРеквизита.Добавить(Префикс);
			КонецЕсли;
		КонецЦикла;
		А1Э_Структуры.УдалитьКлючи(Префиксы, ПрефиксыБезРеквизита);
		
		Для Каждого Пара Из Префиксы Цикл
			Префикс = Пара.Ключ;
			Запрос = Новый Запрос(ТекстЗапросаОтсутствующихНаборов(Префикс));
			Запрос.УстановитьПараметр("ТаблицаПрефикса", Пара.Значение);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(Выборка.СсылкаНабора) Тогда
					А1Э_Механизмы.ДобавитьОписаниеОшибки(Ошибки, "ОтсутствуетНаборРеквизитов", Выборка.Объект, , "Отсутствует элемент справочника <НаборыДополнительныхРеквизитовИСведений>", Истина, 
					А1Э_Структуры.Создать(
					"Префикс", Префикс,
					"ПредставлениеНабора", Выборка.ПредставлениеНабора,
					));
				Иначе
					А1Э_Механизмы.ДобавитьОписаниеОшибки(Ошибки, "НеверноеИмяНабораРеквизитов", Выборка.Объект, Выборка.СсылкаНабора, "Отсутствует элемент справочника <НаборыДополнительныхРеквизитовИСведений>", Истина, 
					А1Э_Структуры.Создать(
					"Префикс", Префикс,
					"ПредставлениеНабора", Выборка.ПредставлениеНабора,
					));
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецФункции
	
	Функция ТаблицаОбъектовИПрефиксов()
		ТаблицаПрефиксов = Новый ТаблицаЗначений;
		ТаблицаПрефиксов.Колонки.Добавить("Префикс", А1Э_Строки.ОписаниеТипа(100));
		ТаблицаПрефиксов.Колонки.Добавить("Объект", А1Э_Строки.ОписаниеТипа(100));
		ТаблицаПрефиксов.Колонки.Добавить("ПредставлениеНабора", А1Э_Строки.ОписаниеТипа(100));
		
		ОбъектыМеханизма = А1Э_Механизмы.ОбъектыМеханизма("А1БСП_ДополнительныеРеквизиты");
		Для Каждого Пара Из ОбъектыМеханизма Цикл
			Объект = Пара.Ключ;
			ОбъектМетаданных = А1Э_Метаданные.ОбъектМетаданных(Объект);
			Контекст = Пара.Значение;
			Строка = ТаблицаПрефиксов.Добавить();
			Строка.Объект = Объект;
			Строка.Префикс = Префикс(ОбъектМетаданных);
			
			Строка.ПредставлениеНабора = А1Э_Структуры.ЗначениеСвойства(Контекст, "ПредставлениеНабора");
			Если НЕ ЗначениеЗаполнено(Строка.ПредставлениеНабора) Тогда
				Строка.ПредставлениеНабора = А1Э_Метаданные.ПредставлениеСписка(ОбъектМетаданных);
			КонецЕсли;
		КонецЦикла;
		Возврат ТаблицаПрефиксов;
	КонецФункции
	
	Функция А1Э_ПриИсправленииОшибок(Ошибки) Экспорт
		Для Каждого Ошибка Из Ошибки Цикл
			Если Ошибка.Имя = "ОтсутствуетНаборРеквизитов" Или Ошибка.Имя = "НеверноеИмяНабораРеквизитов" Тогда
				Если Ошибка.Имя = "ОтсутствуетНаборРеквизитов" Тогда
					НаборРеквизитов = Справочники.НаборыДополнительныхРеквизитовИСведений.СоздатьЭлемент();
					НаборРеквизитов[ИмяРеквизита(Ошибка.Контекст.Префикс)] = Ошибка.ОбъектМетаданных;
				Иначе
					НаборРеквизитов = Ошибка.Ссылка.ПолучитьОбъект();	
				КонецЕсли;
				НаборРеквизитов.Используется = Истина;
				НаборРеквизитов.Наименование = Ошибка.Контекст.ПредставлениеНабора;
				НаборРеквизитов.Записать();
			КонецЕсли;
		КонецЦикла;
		
	КонецФункции 
	
	Функция ФормаЭлементаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
		Контекст = А1Э_Механизмы.КонтекстМеханизма(Форма, "А1БСП_ДополнительныеРеквизиты");
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", А1Э_Структуры.ЗначениеСвойства(Контекст, "ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты"));
		УправлениеСвойствами.ПриСозданииНаСервере(Форма, ДополнительныеПараметры);
	КонецФункции
	
	Функция ФормаПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт 
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		УправлениеСвойствами.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	КонецФункции
	
	Функция ФормаОбработкаЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		УправлениеСвойствами.ОбработкаПроверкиЗаполнения(Форма, Отказ, ПроверяемыеРеквизиты);
	КонецФункции
	
	Функция ФормаПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		УправлениеСвойствами.ПередЗаписьюНаСервере(Форма, ТекущийОбъект);
	КонецФункции 
	
#КонецЕсли
#Если Клиент Тогда
	
	Функция ФормаПриОткрытии(Форма, Отказ) Экспорт
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(Форма);
	КонецФункции
	
	Функция ФормаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
		Если А1Э_Формы.ТипФормы(Форма) <> "ФормаЭлемента" Тогда Возврат Неопределено; КонецЕсли;
		
		//ТУДУ: Необходимы серверные вызовы в обработчиках событий универсальной формы.
		//Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		//	ОбновитьЭлементыДополнительныхРеквизитов();
		//	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		//КонецЕсли;
	КонецФункции 
	
	Функция Подключаемый_СвойстваВыполнитьКоманду(Форма, ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено) Экспорт
		УправлениеСвойствамиКлиент.ВыполнитьКоманду(Форма, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецФункции
	
	Функция Подключаемый_ПриИзмененииДополнительногоРеквизита(Форма, Элемент) Экспорт
		УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(Форма);
	КонецФункции
	
#КонецЕсли

#КонецОбласти 

#Область Общее
#Если НЕ Клиент Тогда
	// Возвращает префикс, используемый механизмом дополнительных реквизитов.
	//
	// Параметры:
	//  Объект	 - 	 - 
	// 
	// Возвращаемое значение:
	//   - 
	//
	Функция Префикс(ОбъектМетаданных) Экспорт
		Если НЕ А1Э_Механизмы.Подключен(ОбъектМетаданных, ИмяМодуля()) Тогда Возврат Неопределено; КонецЕсли;
		Контекст = А1Э_Механизмы.КонтекстМеханизма(ОбъектМетаданных, ИмяМодуля());
		
		Префикс = А1Э_Структуры.ЗначениеСвойства(Контекст, "Префикс");
		Если НЕ ЗначениеЗаполнено(Префикс) Тогда 
			Префикс = А1Э_Строки.Перед(ОбъектМетаданных.Имя, "_"); 
		КонецЕсли;
		Возврат Префикс;
	КонецФункции 
	
#КонецЕсли
#КонецОбласти

Функция ТекстЗапросаОтсутствующихНаборов(Префикс) Экспорт
	Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПрефикса.Объект КАК Объект,
	|	ТаблицаПрефикса.ПредставлениеНабора КАК ПредставлениеНабора
	|ПОМЕСТИТЬ ТаблицаПрефикса
	|ИЗ
	|	&ТаблицаПрефикса КАК ТаблицаПрефикса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПрефикса.Объект КАК Объект,
	|	ТаблицаПрефикса.ПредставлениеНабора КАК ПредставлениеНабора,
	|	Наборы.Ссылка КАК СсылкаНабора,
	|	Наборы.Наименование КАК НаименованиеНабора
	|ИЗ
	|	ТаблицаПрефикса КАК ТаблицаПрефикса
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаборыДополнительныхРеквизитовИСведений КАК Наборы
	|		ПО (ТаблицаПрефикса.Объект = &Наборы_РеквизитВладелец)
	|			И (Наборы.Используется)
	|ГДЕ
	|	(Наборы.Ссылка ЕСТЬ NULL
	|			ИЛИ ТаблицаПрефикса.ПредставлениеНабора <> Наборы.Наименование)";
	А1Э_Строки.Подставить(Текст, "&Наборы_РеквизитВладелец", "Наборы." + ИмяРеквизита(Префикс));
	Возврат Текст;
КонецФункции 

Функция ИмяРеквизита(Префикс) Экспорт
	Возврат Префикс + "_Владелец";	
КонецФункции

Функция ИмяМодуля() Экспорт
	Возврат "А1БСП_ДополнительныеРеквизиты";
КонецФункции 