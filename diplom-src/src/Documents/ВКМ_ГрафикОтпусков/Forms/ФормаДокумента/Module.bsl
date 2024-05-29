#Область ОбработчикиСобытийФормы 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "План отпусков"+?(ЗначениеЗаполнено(Объект.ГодПериод), " на "+XMLСтрока(Год(Объект.ГодПериод)), "")+" год"; 

КонецПроцедуры 
 
&НаКлиенте
Процедура ПриОткрытии(Отказ) 
	
	
	Если Год(Объект.ГодПериод) = 1 Тогда
		ВКМ_СформироватьСписокВыбораГод(Год(ТекущаяДата())); 
		ГодСтрока = Формат(ТекущаяДата(), "ДФ=гггг");
	Иначе
		ВКМ_СформироватьСписокВыбораГод(Год(Объект.ГодПериод));
		ГодСтрока = Формат(Объект.ГодПериод, "ДФ=гггг");
	КонецЕсли;

	ВКМ_ПроверитьКолвоДнейОтпуска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГодСтрокаПриИзменении(Элемент)

	ГодСтрокаПриИзмененииНаСервере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтпускаСотрудников
&НаКлиенте
Процедура ОтпускаСотрудниковДатаОкончанияПриИзменении(Элемент)
	
	  ВКМ_ПроверитьКолвоДнейОтпуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтпускаСотрудниковДатаНачалаПриИзменении(Элемент)  
	
	ВКМ_ПроверитьКолвоДнейОтпуска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура АнализГрафика(Команда)
	
	АдресВХранилище = ВКМ_ПоместитьВоВременноеХранилищеНаСервере();
	Адрес = Новый Структура("АдресВХранилище", АдресВХранилище);
	ОткрытьФорму("Документ.ВКМ_ГрафикОтпусков.Форма.АнализГрафика",Адрес,ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ГодСтрокаПриИзмененииНаСервере()
	
	ВыбрГод = Число(Прав(ГодСтрока, 4));
	Объект.ГодПериод = НачалоГода(Дата(ВыбрГод,1,1));
	Если Объект.Ссылка.ГодПериод <> Объект.ГодПериод Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_СформироватьСписокВыбораГод(Год)  
	
	Элементы.ГодСтрока.СписокВыбора.Очистить();
	Для к = -4 По 5  Цикл
		Элементы.ГодСтрока.СписокВыбора.Добавить(Формат(Год+к, "ЧГ=0"));    
	КонецЦикла;  
	
КонецПроцедуры

&НаСервере
Функция ВКМ_ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ОтпускаСотрудников.Выгрузить(,"Сотрудник,ДатаНачала,ДатаОкончания"), УникальныйИдентификатор); 
	
КонецФункции

&НаКлиенте
Процедура ВКМ_ПроверитьКолвоДнейОтпуска()   
	
	МассивСотрудники = ВКМ_ПолучитьКоличествоДнейОтпуска();
	ВКМ_УстановитьПодсветкуСтрок(МассивСотрудники);
	
КонецПроцедуры

&НаСервере
Процедура ВКМ_УстановитьПодсветкуСтрок(МассивСотрудники)
	
	УсловноеОформление.Элементы.Очистить();
	
	Если МассивСотрудники.Количество() > 0 Тогда
		Для Каждого Сотрудник Из МассивСотрудники Цикл
			ЭлементОформления = УсловноеОформление.Элементы.Добавить(); 
			
			ЭлементОформления.Использование = Истина;  
			ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет (255, 154, 244));
			ЭлементУсловия = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
			ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтпускаСотрудников.Сотрудник"); 
			ЭлементУсловия.ПравоеЗначение = Сотрудник; 
			ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
			ЭлементУсловия.Использование = Истина; 
			
			ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить(); 
			ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ОтпускаСотрудниковСотрудник"); 
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВКМ_ПолучитьКоличествоДнейОтпуска()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Сотрудник КАК Сотрудник,
		|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
		|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания
		|ПОМЕСТИТЬ ВТ_ДанныеДокумента
		|ИЗ
		|	&ТЧОтпускаСотрудников КАК ВложенныйЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеДокумента.Сотрудник КАК Сотрудник,
		|	СУММА(РАЗНОСТЬДАТ(ВТ_ДанныеДокумента.ДатаНачала, ВТ_ДанныеДокумента.ДатаОкончания, ДЕНЬ) + 1) КАК КолвоДней
		|ИЗ
		|	ВТ_ДанныеДокумента КАК ВТ_ДанныеДокумента
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ДанныеДокумента.Сотрудник";
	
	Запрос.УстановитьПараметр("ТЧОтпускаСотрудников", Объект.ОтпускаСотрудников.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Выборка = РезультатЗапроса.Выбрать(); 
		
	МассивСотрудники = Новый Массив;
		
	Пока Выборка.Следующий()Цикл
		
		Если Выборка.КолвоДней > 28 Тогда
			МассивСотрудники.Добавить(Выборка.Сотрудник);
		КонецЕсли;
			
	КонецЦикла;
		
	Возврат МассивСотрудники;
		 
КонецФункции

#КонецОбласти








  


