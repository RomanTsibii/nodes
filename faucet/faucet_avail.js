function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function processAddresses() {
    window.location.href = 'https://faucet.avail.tools/';

    
    // Масив з адресами
    var addresses = [
        "5HNCfmChb8uRZWTLL3Mtr7AfBmogaCjZPLhkVTtq5khx7gMW",
        "5FeLEVRD3UpEFToTAHUS36UJUHk7rFnx6fMroAdxDuKuxZyi",
        "5HT1D9qHTCHahaDbR2RKc5RDS6WgbTE7X3yqDrYFMagDCZ4M",
        "5FpaXNqoxZeLyoFfRExJNo6ChpwB6n9njgM3zDNb3j9GdiRS"
    ];
    
    
    
    function enterAddressAndClick(index) {
        await wait(3000);
      
        // Вибираємо елемент поля вводу за його id
        var addressInput = document.getElementById('address');
    
        // Введення адреса в поле вводу
        debugger;
        var address = addresses[index];
    
        // Забираємо атрибут 'disabled' з кнопки
        var submitButton = document.querySelector('.submit-btn');
        submitButton.removeAttribute('disabled');
    
        // Встановлюємо фокус на поле вводу
        addressInput.focus();
    
        // Викликаємо команду вставки
        document.execCommand('insertText', false, address);
    
        // Функція для перевірки наявності класу "antigate_solver recaptcha solved" та натискання кнопки
        function checkAndClick() {
            var captchaElement = document.querySelector('.antigate_solver.recaptcha.solved');
            if (captchaElement) {
                // Натискання на кнопку для отримання монет
                submitButton.click();
            } else {
                // Повторна перевірка через 1 секунду
                setTimeout(checkAndClick, 1000);
            }
        }
        
        // Початок перевірки для перезагрузки
        checkAndClick();
        
        // Функція для перевірки наявності кнопки "Go back" та перезавантаження сторінки
        function checkAndReload() {
            var reloadButton = document.querySelector('.submit-btn[data-testid="reload"]');
            if (reloadButton) {
                // Перезавантаження сторінки
                location.reload();
            } else {
                // Повторна перевірка через 1 секунду
                setTimeout(checkAndReload, 1000);
            }
        }
        
        // Початок перевірки
        checkAndReload();
    }
    
    // Цикл для виконання операції для кожної адреси
    for (var i = 0; i < addresses.length; i++) {
        enterAddressAndClick(i);
    }

}

// Викликаємо функцію для переходу на сторінку та виконання операцій з адресами
processAddresses();


------------------------------------------------------------------------------

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function processAddresses() {

    var addresses = [
        "5FpaXNqoxZeLyoFfRExJNo6ChpwB6n9njgM3zDNb3j9GdiRS",
        "5FeLEVRD3UpEFToTAHUS36UJUHk7rFnx6fMroAdxDuKuxZyi",
        "5HT1D9qHTCHahaDbR2RKc5RDS6WgbTE7X3yqDrYFMagDCZ4M",
        "5EchU8AuEaRoLjzyoEcKHDtMuc6WnEuLAPTdwAh6S9zJnueU"
    ];

    async function enterAddressAndClick(address) {
        await wait(3000);

        var addressInput = document.getElementById('address');
        var submitButton = document.querySelector('.submit-btn');

        
  
        submitButton.removeAttribute('disabled');
        addressInput.focus();

        document.execCommand('insertText', false, address);

        await wait(1000);

        submitButton.click();

        await waitUntil(() => document.querySelector('.submit-btn[data-testid="reload"]'));
        // location.reload();
    }

    for (const address of addresses) {
        await wait(3000);
        console.info(address)
        await enterAddressAndClick(address);
        await wait(3000);
    }

    // window.location.href = 'https://faucet.avail.tools/';

    await wait(3000);
}

function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function waitUntil(condition) {
    return new Promise(resolve => {
        const interval = setInterval(() => {
            if (condition()) {
                clearInterval(interval);
                resolve();
            }
        }, 1000);
    });
}

processAddresses();














___________________________________________________________



// Вибираємо елемент поля вводу за його id
var addressInput = document.getElementById('address');

// Введення адреса в поле вводу
var address = "5HjNsps1jwR9ctoF5vLeP8BaVf6hc8WSzFBreHGyedGEV8DQ"; // Ваша адреса

// Забираємо атрибут 'disabled' з кнопки
var submitButton = document.querySelector('.submit-btn');
submitButton.removeAttribute('disabled');

// Встановлюємо фокус на поле вводу
addressInput.focus();

// Викликаємо команду вставки
document.execCommand('insertText', false, address);

// Функція для перевірки наявності класу "antigate_solver recaptcha solved" та натискання кнопки
function checkAndClick() {
    var captchaElement = document.querySelector('.antigate_solver.recaptcha.solved');
    if (captchaElement) {
        // Натискання на кнопку для отримання монет
        submitButton.click();
    } else {
        // Повторна перевірка через 1 секунду
        setTimeout(checkAndClick, 1000);
    }
}

// Початок перевірки для перезагрузки
checkAndClick();

// Функція для перевірки наявності кнопки "Go back" та перезавантаження сторінки
function checkAndReload() {
    var reloadButton = document.querySelector('.submit-btn[data-testid="reload"]');
    if (reloadButton) {
        // Перезавантаження сторінки
        location.reload();
    } else {
        // Повторна перевірка через 1 секунду
        setTimeout(checkAndReload, 1000);
    }
}

// Початок перевірки
checkAndReload();



<button class="submit-btn s-X4N2O7xxGY6n" data-testid="reload">Go back</button>
<button class="submit-btn s-r8uHI5gmpRoi" data-testid="reload">Go back</button>








__________________________________________________________________________




// Функція очікування
function wait(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Функція для перевірки наявності елемента
function waitUntil(condition) {
    return new Promise(resolve => {
        const interval = setInterval(() => {
            if (condition()) {
                clearInterval(interval);
                resolve();
            }
        }, 1000);
    });
}

// Функція обробки адресів
async function processAddresses(addresses) {
    window.location.href = 'https://faucet.avail.tools/';

    await wait(3000);

    for (const address of addresses) {
        await enterAddressAndClick(address);
    }
}

// Функція вводу адреси та натискання кнопки
async function enterAddressAndClick(address) {
    await wait(3000);

    var addressInput = document.getElementById('address');
    var submitButton = document.querySelector('.submit-btn');

    // Видалення попереднього значення в полі вводу
    addressInput.value = '';

    // Інтервал між вставками символів
    const interval = 100;

    // Вставка адреси по одному символу
    for (const char of address) {
        addressInput.value += char;
        await wait(interval);
    }

    submitButton.removeAttribute('disabled');
    addressInput.focus();

    await wait(1000);

    submitButton.click();

    await waitUntil(() => document.querySelector('.submit-btn[data-testid="reload"]'));
    location.reload();
}

// Головна функція
async function main() {
    // Масив з адресами
    const addresses = [
        "5HNCfmChb8uRZWTLL3Mtr7AfBmogaCjZPLhkVTtq5khx7gMW",
        "5FeLEVRD3UpEFToTAHUS36UJUHk7rFnx6fMroAdxDuKuxZyi",
        "5HT1D9qHTCHahaDbR2RKc5RDS6WgbTE7X3yqDrYFMagDCZ4M",
        "5FpaXNqoxZeLyoFfRExJNo6ChpwB6n9njgM3zDNb3j9GdiRS"
    ];

    // Зберігаємо дані в локальному сховищі для використання після перезавантаження
    localStorage.setItem('addresses', JSON.stringify(addresses));

    // Викликаємо головну функцію обробки адресів
    await processAddresses(addresses);
}

// Викликаємо головну функцію
main();



