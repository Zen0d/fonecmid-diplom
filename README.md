## ИНСТРУКЦИЯ ПО НАЧАЛЬНОЙ НАСТРОЙКЕ

### Шаг 1.
Первоначально создайте группу и бота в Телеграмм в соответствии с [описанием реализации](telegram.md). Они нужны для отправки уведомлений специалистам о созданных документах «Обслуживание клиента». Уведомления создаются при создании нового документа, а так же при изменении даты и ФИО специалиста.

### Шаг 2.
Заполните следующие константы (Администрирование - Сервис - Дополнительные константы): 
«Токен управления телеграм-ботом» - заполняется токеном бота телеграмм;
«Идентификатор группы для оповещения» - заполняется идентификатором группы телеграмм;
«Номенклатура абонентская плата» - заполняется из справочника «Номенклатура» соответствующим по смыслу наименованием, при необходимости создайте нужную номенклатуру;
«Номенклатура работы специалиста» - заполняется из справочника «Номенклатура» соответствующим по смыслу наименованием, при необходимости создайте нужную номенклатуру.

### Шаг 3.
В справочнике пользователи создайте для каждого сотрудника пользователя. 
На вкладке права доступа назначьте каждому пользователю соответствующий должности профиль группы доступа.

### Шаг 4.
Заполните регистр сведений «Условия оплаты сотрудников», укажите процент от продаж у Специалистов и оклады у всех сотрудников.

### Шаг 5.
В справочник «Графики работы» заведите необходимый вид графика работы, например пятидневка.
За тем в подсистеме «Сервис» выберите обработку «Заполнение графика работы». 
В поле выбор периода выберите период (год) для заполнения графика. В поле «Выходные дни» через запятую перечислите порядковый номер выходного дня недели. Например: 6,7 (как суббота и воскресенье).
В поле «график работы» выберите ранее созданный элемент справочника «Графики работы».
Нажмите кнопку «Заполнить». Далее в регистре «График работы» проверьте корректность заполнения графика. Будьте внимательны, для расчетов с использованием календарных дней, необходимо отдельно создать и заполнить график «Календарные дни».


