<style>
@font-face {
    font-family: 'font';
    src: url('/public/_.ttf') format('truetype');
}

.visually-hidden {
    font-family: 'font', sans-serif;
}
</style>
<div class="table-responsive"><table class="table table-bordered table-condensed">
<thead><tr><th>Service</th><th>Contact</th></tr></thead>
<tbody>
    <tr>
        <td>
        <svg xmlns="http://w3.org" width="16" height="16" viewBox="0 0 16 16"><path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg> GitHub</td><td><a href="https://github.com/ichensky" target="_blank" rel="noopener noreferrer nofollow" class="external">ichensky</a></td>
    </tr>
    <tr>
        <td><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><title>leetcode</title><path fill="currentColor" d="M13.483 0a1.37 1.37 0 0 0-.961.438L7.116 6.226l-3.854 4.126a5.3 5.3 0 0 0-1.209 2.104a5 5 0 0 0-.125.513a5.5 5.5 0 0 0 .062 2.362a6 6 0 0 0 .349 1.017a5.9 5.9 0 0 0 1.271 1.818l4.277 4.193l.039.038c2.248 2.165 5.852 2.133 8.063-.074l2.396-2.392c.54-.54.54-1.414.003-1.955a1.38 1.38 0 0 0-1.951-.003l-2.396 2.392a3.02 3.02 0 0 1-4.205.038l-.02-.019l-4.276-4.193c-.652-.64-.972-1.469-.948-2.263a2.7 2.7 0 0 1 .066-.523a2.55 2.55 0 0 1 .619-1.164L9.13 8.114c1.058-1.134 3.204-1.27 4.43-.278l3.501 2.831c.593.48 1.461.387 1.94-.207a1.384 1.384 0 0 0-.207-1.943l-3.5-2.831c-.8-.647-1.766-1.045-2.774-1.202l2.015-2.158A1.384 1.384 0 0 0 13.483 0m-2.866 12.815a1.38 1.38 0 0 0-1.38 1.382a1.38 1.38 0 0 0 1.38 1.382H20.79a1.38 1.38 0 0 0 1.38-1.382a1.38 1.38 0 0 0-1.38-1.382z"/></svg> Leetcode</td><td><a href="https://leetcode.com/u/ichensky/" target="_blank" rel="noopener noreferrer nofollow" class="external">ichensky</a></td>
    </tr>
    <tr>
        <td>&gt;_ Wechall</td>
        <td>
            Look deeper.
            <a href="https://www.wechall.net/profile/" style="display: none;" rel="noopener noreferrer nofollow">Wechall profile</a>
            <p class="visually-hidden">
            A place to gather, a place to hide, should be well hidden and plain in sight.
            Where should you start how to begin, if nothings here except a thin
            phrase of text and random words, are you still lost does the brain hurts?
            </p>
        </td>
    </tr>
    <tr>
        <td>&#128390; Email</td><td><a href="mailto:ichensky@live.com">ichensky@live.com</a></td>
    </tr>
</tbody>
</table></div>
<script>
    function help() {
        console.log("Available commands:");
        console.log("0. help() - Show available commands.");
        console.log("1. skills() - Display my technical stack in a clean table.");
        console.log("2. connection() - Check the connection.");
        console.log("3. hint() - Get a secret hint.");
    }
    function connection() {
        console.log("%c599C73", "color: #599C73");
    }
    function skills() {
        console.log("My Technical skills:");
        console.table([
            { Category: "Frontend", Tech: "JavaScript, TypeScript, Angular", Level: "Expert" },
            { Category: "Backend", Tech: ".NET, C#", Level: "Expert" },
            { Category: "Cloud", Tech: "Azure", Level: "Expert" }
        ]);
    }
    function hint() {
        console.log("Western Union, 1859");
    }
(() => {
  const primaryStyle = "color: #55e255; font-family: monospace; font-size: 13px; font-weight: bold;";
  const secondaryStyle = "color: #5555e2; font-family: monospace; font-size: 12px;";
  const commandStyle = "color: #e25555; font-family: monospace; font-size: 12px; font-weight: bold; background: #222; padding: 1px 5px; border-radius: 3px;";
  setTimeout(() => {
    console.log("%c\n🤖 [SYSTEM INITIALIZING]...\nWelcome, User!", primaryStyle);
    console.log("%cType %chelp()%c and press Enter to explore the terminal menu.", secondaryStyle, commandStyle, secondaryStyle);
    console.log("\n");
  }, 1000);
})();
</script>