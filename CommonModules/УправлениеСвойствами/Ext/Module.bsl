﻿//Добавляем кнопку для добавления полей к самим полям
&После("СоздатьОсновныеОбъектыФормы")
Процедура А1БСП_СоздатьОсновныеОбъектыФормы(Форма, Контекст, СоздатьОписаниеДополнительныхРеквизитов)
	Попытка
		ОпцияИспользоватьСвойства = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьДополнительныеРеквизитыИСведения");
		ДобавитьКомандуСоздания = ОпцияИспользоватьСвойства И СоздатьОписаниеДополнительныхРеквизитов;
		МассивОписаний = Новый Массив;
		Если ДобавитьКомандуСоздания Тогда
			А1Э_Формы.ДобавитьОписаниеКомандыИКнопки(МассивОписаний, "А1БСП_ДобавитьРеквизит", "Подключаемый_СвойстваВыполнитьКоманду", , "Добавить новое поле", Форма.Свойства_ИмяЭлементаДляРазмещения, , ,
			А1Э_Структуры.Создать(
			"Картинка", БиблиотекаКартинок.СоздатьЭлементСписка,
			"Отображение", ОтображениеКнопки.КартинкаИТекст, 
			)); 
		КонецЕсли;
		А1Э_Формы.ДобавитьРеквизитыИЭлементы(Форма, МассивОписаний);
		
		Если ОпцияИспользоватьСвойства И СоздатьОписаниеДополнительныхРеквизитов Тогда
			Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений) Тогда
				Форма.Элементы.А1БСП_ДобавитьРеквизит.Доступность = Ложь;
				Форма.Элементы.А1БСП_ДобавитьРеквизит.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСправа;
				Форма.Команды.А1БСП_ДобавитьРеквизит.Подсказка = "У Вас недостаточно прав для добавления полей. Обратитесь к администратору."; 
			КонецЕсли;
		КонецЕсли;
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
КонецПроцедуры
