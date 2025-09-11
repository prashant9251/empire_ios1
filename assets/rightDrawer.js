

function rightDrawerAdd() {
    var html = `<!-- drawer.html -->
    <div id="rightDrawer">
            <div id="drawer">
            <br>
            <br>
            <br>
                <h2 id="rightDrawerHeading">Drawer Content</h2>
                <div id="rightDrawerContent"></div>
            </div>

            <button id="rightDrawermMenuButton"></button>
</div>
<style>
    #drawer {
        position: fixed;
        top: 0;
        right: -300px;
        width: 300px;
        height: 100%;
        background: #f3f3f3;
        box-shadow: -2px 0 5px rgba(0, 0, 0, 0.3);
        transition: right 0.3s ease;
        padding: 20px;
        box-sizing: border-box;
        z-index: 1000;
    }

    #drawer.open {
        right: 0;
    }

    #rightDrawermMenuButton {
        position: fixed;
        top: 20px;
        right: 0;
        background: #4CAF50;
        color: white;
        border: none;
        padding: 10px 15px;
        cursor: grab;
        z-index: 1001;
        border-radius: 8px 0 0 8px;
        font-size: 18px;
    }
</style>`;

    var drawer = document.createElement('body');
    drawer.innerHTML = html;
    document.body.appendChild(drawer);

    var toggleBtn = document.getElementById('rightDrawermMenuButton');
    var drawerElement = document.getElementById('drawer');

    toggleBtn.addEventListener('click', function () {
        if (drawerElement.classList.contains('open')) {
            drawerElement.classList.remove('open');
            toggleBtn.innerHTML = '➤';
        } else {
            drawerElement.classList.add('open');
            toggleBtn.innerHTML = '◀';
        }
    });

}
