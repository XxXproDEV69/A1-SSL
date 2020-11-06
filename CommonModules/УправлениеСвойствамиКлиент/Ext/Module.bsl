﻿
&После("ВыполнитьКоманду")
Процедура А1БСП_ВыполнитьКоманду(Форма, Элемент, СтандартнаяОбработка)
	Если ТипЗнч(Элемент) <> Тип("КомандаФормы") Тогда Возврат; КонецЕсли;
	
	Если Элемент.Имя = "А1БСП_ДобавитьРеквизит" Тогда
		ПоложениеВторойТочки = СтрНайти(Форма.ИмяФормы, ".", , , 2);
		ИмяНабора = СтрЗаменить(Лев(Форма.ИмяФормы, ПоложениеВторойТочки - 1), ".", "_"); 
		ТекущийНабор = А1Э_ОбщееСервер.РезультатФункции("УправлениеСвойствамиСлужебный.А1БСП_ОсновнойНаборСвойств", Форма.Объект.Ссылка);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НаборСвойств", ТекущийНабор);
		ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Ложь);
		ПараметрыФормы.Вставить("ТекущийНаборСвойств", ТекущийНабор);
		
		ОткрываемаяФорма = "ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.ФормаОбъекта";
		ОткрытьФорму(ОткрываемаяФорма, ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

&Вместо("ПослеЗагрузкиДополнительныхРеквизитов")
// Для механизма подключаем обработчик ожидания через универсальную форму.
//
// Параметры:
//  Форма	 - 	 - 
//
Процедура А1БСП_ПослеЗагрузкиДополнительныхРеквизитов(Форма)
	Если НЕ Форма.Свойства_ИспользоватьСвойства
		Или НЕ Форма.Свойства_ИспользоватьДопРеквизиты Тогда
		Возврат;
	КонецЕсли;
	
	Если А1Э_УниверсальнаяФорма.Инициализирована(Форма) Тогда
		А1Э_УниверсальнаяФорма.ПодключитьУниверсальныйОбработчикОжидания(Форма, 
		"УправлениеСвойствамиКлиент.А1БСП_ОбновитьЗависимостиДополнительныхРеквизитов", 2);
	Иначе
		Форма.ПодключитьОбработчикОжидания("ОбновитьЗависимостиДополнительныхРеквизитов", 2);
	КонецЕсли;
КонецПроцедуры

// Для вызова стандартной процедуры как функции.
//
// Параметры:
//  Форма	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция А1БСП_ОбновитьЗависимостиДополнительныхРеквизитов(Форма) Экспорт
	ОбновитьЗависимостиДополнительныхРеквизитов(Форма);
	Возврат Неопределено;
КонецФункции 
