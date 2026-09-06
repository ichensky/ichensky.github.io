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

* **Languages & Frameworks:** C#, .NET, ASP.NET Core, TypeScript, JavaScript, Node.js, Angular
* **System Design:** Domain-Driven Design (DDD), Clean Architecture, Distributed Systems
* **Cloud & Operations:** Azure (Service Bus, App Services, Functions, Key Vault, Application Insights, Entra ID), Docker, Kubernetes, CI/CD
* **Databases:** MS SQL Server, MongoDB, Redis

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