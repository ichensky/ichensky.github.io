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
        <td>Github</td><td><a href="https://github.com/ichensky" target="_blank" rel="noopener noreferrer nofollow" class="external">ichensky</a></td>
    </tr>
    <tr>
        <td>Leetcode</td><td><a href="https://leetcode.com/u/ichensky/" target="_blank" rel="noopener noreferrer nofollow" class="external">ichensky</a></td>
    </tr>
    <tr>
        <td>Wechall</td>
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
        <td>X</td>
        <td><a href="https://x.com/ichensky" target="_blank" rel="noopener noreferrer nofollow" class="external">ichensky</a></td>
        </tr>
        <tr>
        <td>email</td>
        <td>ichensky@live.com</td>
    </tr>
</tbody>
</table></div>
<script>
    function help() {
        console.log("Available commands:");
        console.log("0. help() - Show available commands.");
        console.log("1. skills() - Display some of my technical stack in a clean table.");
        console.log("2. connection() - Check if the connection is active.");
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