<style>
    .flag{
        float: left;
    }
</style>
<div class="flag">
    <canvas id="flagCanvas" width="200" height="150"></canvas>
</div>

**About**

Building reliable cloud platforms and fast backends takes more than writing code, it needs simple, solid foundations built to grow. Software breaks down without focus; progress comes from `skipping hype` and delivering steady, tested systems.

<hr>

**Core Principles**

1. **Clear Code Over Tricks**
Hidden complexity brings hidden bugs. Clear rules and early checks make systems easy to understand, fix, and maintain.
2. **Practical Design**
Good design keeps core business logic separate from underlying tools. This keeps code clean so teams can release features quickly without breaking production.
3. **Data-Driven Performance**
Speed comes from real measurements, tests, and heavy-load profiling—never guessing. Performance improves by finding and fixing exact bottlenecks in memory, databases, and networks.

---

**Experience & Focus**

Tested in high-traffic environments, my work centers on leading tech teams, updating old software, and scaling backends. Outside cloud systems, I focus on code efficiency, CPU performance, and low-level memory tuning.

---

**Main Stack**

* **Languages & Frameworks:** <svg xmlns="http://w3.org" viewBox="0 0 16 16" width="16" height="16">
  <path d="M8 0l6.5 3.75v8.5L8 16l-6.5-3.75v-8.5z" fill="#9B4F96"/>
  <path d="M7.8 5.2c-.4 0-.7.1-1 .3-.3.3-.5.7-.5 1.3v2.4c0 .6.2 1 .5 1.3.3.2.6.3 1 .3.4 0 .8-.1 1.1-.4v1.2c-.3.2-.7.3-1.3.3-.9 0-1.6-.3-2-.9-.4-.5-.6-1.3-.6-2.3V6.6c0-1 .2-1.8.6-2.3.4-.6 1.1-.9 2-.9.6 0 1 .1 1.3.3v1.2c-.3-.2-.7-.3-1.1-.3z" fill="#FFFFFF"/>
  <path d="M11.5 4.5h.7l-.3 2.1h1.4v.6h-1.5l-.3 1.6h1.5v.6h-1.6l-.3 2.1h-.7l.3-2.1H9.6l-.3 2.1h-.7l.3-2.1H7.8v-.6h1.2l.3-1.6H8.1v-.6h1.3l.3-2.1h.7l-.3 2.1h1.4l.3-2.1zm-.5 2.7H9.6l-.3 1.6h1.4l.3-1.6z" fill="#FFFFFF"/>
</svg> C#, .NET, ASP.NET Core, TypeScript, JavaScript, Node.js, Angular
* **System Design:** <svg xmlns="http://w3.org" viewBox="0 0 16 16" width="16" height="16"> <path d="M6 1.5l4.5 2.6v5.2L6 11.9 1.5 9.3V4.1z" fill="#0078D4" fill-opacity="0.15" stroke="#0078D4" stroke-width="1.2" stroke-linejoin="round"/> <path d="M10.5 5.5l4 2.3v4.6l-4 2.3-4-2.3V7.8z" fill="#00828A" fill-opacity="0.15" stroke="#00828A" stroke-width="1.2" stroke-linejoin="round"/> <path d="M6.5 7.8L10.5 5.5v2.3L6.5 10.1z" fill="#00BCF2" opacity="0.4"/> <circle cx="6" cy="6.7" r="1.5" fill="#0078D4"/> <line x1="6" y1="6.7" x2="3.5" y2="5.2" stroke="#0078D4" stroke-width="1" stroke-linecap="round"/> <line x1="6" y1="6.7" x2="8.5" y2="5.2" stroke="#0078D4" stroke-width="1" stroke-linecap="round"/> <line x1="6" y1="6.7" x2="6" y2="9.5" stroke="#0078D4" stroke-width="1" stroke-linecap="round"/> <circle cx="10.5" cy="10.1" r="1.2" fill="#00828A"/>
</svg> Domain-Driven Design (DDD), Clean Architecture, Distributed Systems
* **Cloud & Operations:** <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="16" height="16"> <defs> <linearGradient id="azureGrad" x1="0%" y1="0%" x2="100%" y2="100%"> <stop offset="0%" stop-color="#0078D4"/> <stop offset="100%" stop-color="#50E6FF"/> </linearGradient> </defs> <path fill="url(#azureGrad)" d="M12.5 6A4.5 4.5 0 0 0 8.1 3a4.5 4.5 0 0 0-4.3 3.1A3.5 3.5 0 0 0 0 9.5 3.5 3.5 0 0 0 3.5 13h9a3.5 3.5 0 0 0 3.5-3.5A3.5 3.5 0 0 0 12.5 6z"/>
</svg>
 Azure (Service Bus, App Services, Functions, Key Vault, Application Insights, Entra ID), Docker, Kubernetes, CI/CD
* **Databases:** <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" aria-label="Microsoft SQL Server"> <rect width="16" height="16" rx="2" fill="#CC2927"/> <ellipse cx="8" cy="4" rx="4.2" ry="1.8" fill="none" stroke="#fff" stroke-width="1"/> <path d="M3.8 4v6.2c0 1 1.9 1.8 4.2 1.8s4.2-.8 4.2-1.8V4" fill="none" stroke="#fff" stroke-width="1"/> <path d="M3.8 7c0 1 1.9 1.8 4.2 1.8s4.2-.8 4.2-1.8" fill="none" stroke="#fff" stroke-width="1"/> </svg> MS SQL Server, MongoDB, Redis

---

**Let's Connect**

Looking for detailed technical guides? Check out the **Docs** section.

If your team needs to fix performance issues or scale up a complex system, reach out at <ichensky@live.com>.

<script>
    const canvas = document.getElementById('flagCanvas');
    const ctx = canvas.getContext('2d');

    // Dimensions & Positioning
    const flagWidth = canvas.width * 0.75;
    const flagHeight = flagWidth * 0.6;
    const startX = (canvas.width - flagWidth) / 2 + 10;
    const startY = (canvas.height - flagHeight) / 2;

    // Pole Geometry (Slim, golden, 3D shaded)
    const poleWidth = 4;
    const poleX = startX - 6;
    const poleCenterX = poleX + (poleWidth / 2);

    // Simulation State
    let time = 0;
    let noiseTime = 0;
    const baseFreq = 0.025;
    const baseAmp = 18;

    // Pseudo-random noise helper
    function getNoise(x, t) {
        return Math.sin(x * 0.07 + t * 1.3) * Math.cos(x * 0.031 - t * 0.9) +
               Math.sin(x * 0.013 - t * 2.1) * 0.5;
    }

    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // Organic wind velocity fluctuations
        const windNoise = Math.sin(time * 0.3) * 0.15 + Math.cos(time * 0.77) * 0.1;
        const gustFactor = 1 + windNoise;
        const currentSpeed = 0.045 * gustFactor;
        
        time += currentSpeed;
        noiseTime += 0.02;

        // 1. Draw Golden Flagpole with Cylindrical 3D Shading
        const poleGradient = ctx.createLinearGradient(poleX, 0, poleX + poleWidth, 0);
        poleGradient.addColorStop(0.0, '#7A5200'); // Shadowed left rim
        poleGradient.addColorStop(0.35, '#FFF0A0'); // Specular highlight ridge
        poleGradient.addColorStop(0.7, '#D4AF37'); // Metallic gold base
        poleGradient.addColorStop(1.0, '#4A3200'); // Deep shadowed right edge

        ctx.fillStyle = poleGradient;
        ctx.fillRect(poleX, startY - 14, poleWidth, flagHeight + 44);

        // Soft Drop Shadow behind the pole itself
        ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
        ctx.fillRect(poleX - 1, startY - 14, 1, flagHeight + 44);

        // Cast Shadow onto the pole where the flag attaches
        ctx.fillStyle = 'rgba(0, 0, 0, 0.45)';
        ctx.fillRect(poleX, startY, poleWidth, flagHeight);

        // Golden Finial Ball with 3D Spherical Shading
        const ballRadius = 4;
        const ballY = startY - 14;

        const ballGradient = ctx.createRadialGradient(
            poleCenterX - 1.2, ballY - 1.2, 0.2,
            poleCenterX, ballY, ballRadius
        );
        ballGradient.addColorStop(0.0, '#FFFFFF'); // Hot spot specular light
        ballGradient.addColorStop(0.3, '#FFE57F'); // Bright gold
        ballGradient.addColorStop(0.8, '#C59B27'); // Metallic body
        ballGradient.addColorStop(1.0, '#5C3A00'); // Ambient shadow boundary

        ctx.fillStyle = ballGradient;
        ctx.beginPath();
        ctx.arc(poleCenterX, ballY, ballRadius, 0, Math.PI * 2);
        ctx.fill();

        // 2. Render Flag Slices (Vertical Mesh)
        for (let x = 0; x < flagWidth; x++) {
            const progress = x / flagWidth;
            
            // Fixed anchor on left pole, wave grows toward free edge
            const pinFactor = Math.pow(progress, 1.2);

            // Primary wave + secondary harmonic ripple + organic turbulence noise
            const primaryWave = Math.sin(x * baseFreq - time) * baseAmp;
            const secondaryRipple = Math.sin(x * baseFreq * 2.3 - time * 1.8) * (baseAmp * 0.35);
            const randomTurbulence = getNoise(x, noiseTime) * (baseAmp * 0.3);
            
            const totalYOffset = (primaryWave + secondaryRipple + randomTurbulence) * pinFactor;

            // Horizontal cloth compression/warp
            const slope = Math.cos(x * baseFreq - time);
            const xOffset = slope * 3 * pinFactor;
            const currentX = startX + x + xOffset;

            // Dynamic lighting intensity
            const lightIntensity = Math.cos(x * baseFreq - time + 0.3 + getNoise(x, noiseTime) * 0.2);

            // Base Colors
            const blue = '#0057B7';
            const yellow = '#FFD700';

            // Draw Top Half (Blue)
            ctx.fillStyle = blue;
            ctx.fillRect(currentX, startY + totalYOffset, 1.5, flagHeight / 2);

            // Draw Bottom Half (Yellow)
            ctx.fillStyle = yellow;
            ctx.fillRect(currentX, startY + (flagHeight / 2) + totalYOffset, 1.5, flagHeight / 2);

            // 3. High-Intensity Lighting & Shadow Layer
            if (lightIntensity > 0) {
                const highlightAlpha = Math.pow(lightIntensity, 1.2) * 0.65;
                ctx.fillStyle = `rgba(255, 255, 255, ${highlightAlpha})`;
            } else {
                const shadowAlpha = Math.abs(lightIntensity) * 0.35;
                ctx.fillStyle = `rgba(0, 0, 0, ${shadowAlpha})`;
            }
            ctx.fillRect(currentX, startY + totalYOffset, 1.5, flagHeight);

            // Ambient Occlusion shadow near pole attachment
            if (x < 20) {
                const poleShadow = (1 - x / 20) * 0.2;
                ctx.fillStyle = `rgba(0, 0, 0, ${poleShadow})`;
                ctx.fillRect(currentX, startY + totalYOffset, 1.5, flagHeight);
            }
        }

        // 4. Soft Ground Shadow
        ctx.save();
        ctx.filter = 'blur(12px)';
        ctx.fillStyle = 'rgba(0, 0, 0, 0.12)';
        ctx.beginPath();
        ctx.ellipse(canvas.width / 2, startY + flagHeight + 40, flagWidth * 0.45, 10, 0, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();

        requestAnimationFrame(animate);
    }

    animate();
</script>