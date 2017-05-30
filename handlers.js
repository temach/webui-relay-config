/**
 * Created by artem on 5/29/17.
 */

document.getElementById('read_button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/read');
    xhr.onload = function() {
        if (xhr.status === 200) {
            var parts = xhr.responseText.split('@');
            document.getElementById('read_temperature').textContent = parts[0];
            document.getElementById('read_humidity').textContent = parts[1];
        }
        else {
            alert('Ошибка при чтении значения датчика: ' + xhr.status);
        }
    };
    xhr.send();
});

document.getElementById('get_button').addEventListener('click', function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/get');
    xhr.onload = function() {
        if (xhr.status === 200) {
            var parts = xhr.responseText.split('@');
            document.getElementById('get_temperature').textContent = parts[0];
            document.getElementById('get_humidity').textContent = parts[1];
        }
        else {
            alert('Ошибка при чтении уровней включения реле: ' + xhr.status);
        }
    };
    xhr.send();
});

document.getElementById('set_button').addEventListener('click', function() {
    var newTemp = document.getElementById('tempThreshold').value;
    var newHumidity = document.getElementById('humidityThreshold').value;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/set');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.status === 200) {
            var response = xhr.responseText.split('@');
            if (response[0] !== newTemp || response[1] !== newHumidity) {
                alert('Ошибка при установления нового уровня включения реле: ' + xhr.responseText);
            }
        }
        else if (xhr.status !== 200) {
            alert('Ошибка при установке нового уровня включения реле: ' + xhr.status);
        }
    };
    xhr.send(encodeURI(newTemp) + '@' + encodeURI(newHumidity));
});


