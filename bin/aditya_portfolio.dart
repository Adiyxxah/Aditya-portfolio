import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aditya Kumar Pradhan - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFF00D4FF),
          surface: Color(0xFF12121A),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  // --- Animation Controllers ---
  late AnimationController _heroController;
  late AnimationController _particleController;
  late AnimationController _scrollController;

  // --- Animations ---
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late Animation<double> _titleScale;

  // --- State ---
  int _selectedSection = 0;
  final ScrollController _mainScroll = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  final List<String> _navItems = [
    'Home', 'About', 'Experience', 'Skills', 'Projects'
  ];

  @override
  void initState() {
    super.initState();

    // Hero animation - runs once on load
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Particle background animation - loops forever
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Scroll controller for navbar highlight
    _scrollController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define what each animation does
    _heroFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _titleScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Start the hero animation after a tiny delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _heroController.forward();
    });

    // Listen to scroll to update navbar
    _mainScroll.addListener(_onScroll);
  }

  void _onScroll() {
    // Future enhancement: detect which section is visible
  }

  @override
  void dispose() {
    _heroController.dispose();
    _particleController.dispose();
    _scrollController.dispose();
    _mainScroll.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    setState(() => _selectedSection = index);
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated particle background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) => CustomPaint(
              painter: ParticlePainter(_particleController.value),
              size: MediaQuery.of(context).size,
            ),
          ),

          // Main content
          Column(
            children: [
              // Top navbar
              _buildNavBar(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: _mainScroll,
                  child: Column(
                    children: [
                      // Section 0: Hero
                      _buildHeroSection(),

                      // Section 1: About
                      _buildAboutSection(),

                      // Section 2: Experience
                      _buildExperienceSection(),

                      // Section 3: Skills
                      _buildSkillsSection(),

                      // Section 4: Projects
                      _buildProjectsSection(),

                      // Footer
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  //  NAVBAR
  // =====================================================
  Widget _buildNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0F).withOpacity(0.9),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF6C63FF).withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 32),

          // Logo
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
            ).createShader(bounds),
            child: const Text(
              'AKP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),

          const Spacer(),

          // Nav items
          ...List.generate(_navItems.length, (i) {
            final isSelected = _selectedSection == i;
            return GestureDetector(
              onTap: () => _scrollToSection(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C63FF).withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.6))
                      : null,
                ),
                child: Text(
                  _navItems[i],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : Colors.white.withOpacity(0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 32),
        ],
      ),
    );
  }

  // =====================================================
  //  HERO SECTION
  // =====================================================
  Widget _buildHeroSection() {
    return Container(
      key: _sectionKeys[0],
      height: MediaQuery.of(context).size.height - 65,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _heroFade,
        child: SlideTransition(
          position: _heroSlide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile avatar with glowing border
              ScaleTransition(
                scale: _titleScale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'AKP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // "Hi, I'm" label
              const _TypewriterText(
                text: "Hi there 👋 I'm",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF00D4FF),
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 12),

              // Name with gradient
              ScaleTransition(
                scale: _titleScale,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF00D4FF), Color(0xFFFF6CAB)],
                  ).createShader(bounds),
                  child: const Text(
                    'Aditya Kumar Pradhan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Role tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                ),
                child: const Text(
                  '📊 Data Analyst  •  Power BI  •  SQL  •  Python',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tagline
              const Text(
                'Turning raw data into insights that drive decisions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 40),

              // CTA Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GlowButton(
                    label: 'View My Work',
                    icon: Icons.arrow_downward_rounded,
                    onTap: () => _scrollToSection(2),
                  ),
                  const SizedBox(width: 16),
                  _OutlineButton(
                    label: 'Contact Me',
                    icon: Icons.mail_outline_rounded,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Social links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialChip(label: 'GitHub', icon: Icons.code),
                  const SizedBox(width: 12),
                  _SocialChip(label: 'LinkedIn', icon: Icons.person),
                  const SizedBox(width: 12),
                  _SocialChip(
                      label: 'pradhan.adi586@gmail.com', icon: Icons.email_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  //  ABOUT SECTION
  // =====================================================
  Widget _buildAboutSection() {
    return _SectionWrapper(
      sectionKey: _sectionKeys[1],
      title: 'About Me',
      subtitle: 'Who I am',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: text
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "I'm a motivated MCA graduate from Lovely Professional University "
                      "with hands-on experience in data analysis, SQL, cloud storage, and "
                      "business intelligence dashboards. I love finding stories hidden in data "
                      "and turning them into actionable business insights.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _InfoChip(label: '📍 Bhanjanagar, Odisha'),
                    _InfoChip(label: '🎓 MCA – LPU (6.78 CGPA)'),
                    _InfoChip(label: '📞 +91-7326886586'),
                    _InfoChip(label: '💼 Open to Opportunities'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          // Right: stats
          Expanded(
            flex: 2,
            child: Column(
              children: const [
                _StatCard(number: '2+', label: 'Years Experience'),
                SizedBox(height: 16),
                _StatCard(number: '3', label: 'Internships'),
                SizedBox(height: 16),
                _StatCard(number: '5+', label: 'Certifications'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  //  EXPERIENCE SECTION
  // =====================================================
  Widget _buildExperienceSection() {
    return _SectionWrapper(
      sectionKey: _sectionKeys[2],
      title: 'Experience',
      subtitle: 'My Journey',
      child: Column(
        children: [
          _ExperienceCard(
            role: 'Associate',
            company: 'Tech Mahindra',
            period: 'Aug 2025 – Apr 2026',
            color: const Color(0xFF6C63FF),
            icon: Icons.business,
            bullets: const [
              'Collected and cleaned product datasets using Excel and SQL',
              'Built interactive Power BI dashboards for product performance insights',
              'Managed SKU systems and AWS S3 image storage for inventory',
              'Collaborated cross-functionally to validate large volumes of product data',
            ],
          ),
          const SizedBox(height: 24),
          _ExperienceCard(
            role: 'Junior Analyst Intern',
            company: 'Tech3i',
            period: 'Aug 2023 – Aug 2024',
            color: const Color(0xFF00D4FF),
            icon: Icons.analytics,
            bullets: const [
              'Supported ETL processes for structured data migration',
              'Wrote and optimized SQL queries for internal reporting',
              'Performed data validation to ensure data integrity',
              'Enhanced Excel-based reports with advanced formulas',
            ],
          ),
          const SizedBox(height: 24),
          _ExperienceCard(
            role: 'Flutter Developer Intern',
            company: 'Software Lab',
            period: 'May 2023 – Aug 2023',
            color: const Color(0xFFFF6CAB),
            icon: Icons.phone_android,
            bullets: const [
              'Built mobile app UIs using Flutter framework',
              'Integrated RESTful APIs for real-time data display',
              'Collaborated on UI/UX improvements and design discussions',
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  //  SKILLS SECTION
  // =====================================================
  Widget _buildSkillsSection() {
    return _SectionWrapper(
      sectionKey: _sectionKeys[3],
      title: 'Skills',
      subtitle: 'What I work with',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkillGroup(
            category: '📊 Data Tools',
            skills: const [
              _SkillItem('Power BI', 0.85),
              _SkillItem('Excel', 0.90),
              _SkillItem('Tableau', 0.70),
              _SkillItem('Pandas', 0.75),
            ],
          ),
          const SizedBox(height: 32),
          _SkillGroup(
            category: '💻 Languages',
            skills: const [
              _SkillItem('SQL', 0.85),
              _SkillItem('Python', 0.75),
              _SkillItem('Dart', 0.65),
            ],
          ),
          const SizedBox(height: 32),
          _SkillGroup(
            category: '☁️ Cloud & Databases',
            skills: const [
              _SkillItem('MySQL', 0.80),
              _SkillItem('AWS S3', 0.60),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            '🔑 Key Concepts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _TagChip('Data Cleaning'),
              _TagChip('Data Visualization'),
              _TagChip('EDA'),
              _TagChip('Basic ETL'),
              _TagChip('Dashboard Design'),
              _TagChip('Data Validation'),
              _TagChip('Report Automation'),
              _TagChip('Inventory Management'),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  //  PROJECTS SECTION (placeholder for future projects)
  // =====================================================
  Widget _buildProjectsSection() {
    return _SectionWrapper(
      sectionKey: _sectionKeys[4],
      title: 'Projects',
      subtitle: 'What I have built',
      child: Column(
        children: [
          // Placeholder project cards - Aditya will add real ones here
          _ProjectCard(
            title: 'Sales Dashboard – Power BI',
            description:
            'Interactive Power BI dashboard visualizing product sales KPIs, '
                'inventory levels, and category performance with drill-down filters.',
            tags: const ['Power BI', 'Excel', 'SQL'],
            color: const Color(0xFF6C63FF),
            icon: Icons.bar_chart,
            githubUrl: 'https://github.com/Adiyxxah',
            isComingSoon: false,
          ),
          const SizedBox(height: 20),
          _ProjectCard(
            title: 'EDA on E-Commerce Dataset',
            description:
            'Exploratory data analysis on a large e-commerce dataset using '
                'Pandas and Matplotlib to uncover customer behaviour patterns.',
            tags: const ['Python', 'Pandas', 'Matplotlib'],
            color: const Color(0xFF00D4FF),
            icon: Icons.data_exploration,
            githubUrl: 'https://github.com/Adiyxxah',
            isComingSoon: false,
          ),
          const SizedBox(height: 20),
          _ProjectCard(
            title: 'Your Next Project',
            description:
            'Add your real projects here! Edit the _buildProjectsSection() '
                'method in main.dart and replace this card with your actual work.',
            tags: const ['Coming Soon'],
            color: const Color(0xFFFF6CAB),
            icon: Icons.add_circle_outline,
            githubUrl: 'https://github.com/Adiyxxah',
            isComingSoon: true,
          ),
        ],
      ),
    );
  }

  // =====================================================
  //  FOOTER
  // =====================================================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
            ).createShader(bounds),
            child: const Text(
              'Aditya Kumar Pradhan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data Analyst • Power BI • SQL • Python',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Text(
            '© 2025 Aditya Kumar Pradhan. Built with Flutter 💜',
            style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// =====================================================
//  REUSABLE WIDGETS
// =====================================================

/// Wraps each major section with consistent padding, title, and scroll key
class _SectionWrapper extends StatelessWidget {
  final GlobalKey sectionKey;
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionWrapper({
    required this.sectionKey,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label (small, colored)
          Text(
            subtitle.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6C63FF),
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Section title
          Text(
            title,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          // Decorative underline
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 48),
          child,
        ],
      ),
    );
  }
}

/// Animated "glowing" primary button
class _GlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GlowButton({required this.label, required this.icon, required this.onTap});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.6),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, size: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined secondary button
class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.icon, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF6C63FF).withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, size: 16, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small chip for social links
class _SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SocialChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white38),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

/// Pill chip for about section info
class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    );
  }
}

/// Animated number stat card
class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
            ).createShader(bounds),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}

/// Experience timeline card
class _ExperienceCard extends StatefulWidget {
  final String role;
  final String company;
  final String period;
  final Color color;
  final IconData icon;
  final List<String> bullets;

  const _ExperienceCard({
    required this.role,
    required this.company,
    required this.period,
    required this.color,
    required this.icon,
    required this.bullets,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _expanded
                ? widget.color.withOpacity(0.5)
                : widget.color.withOpacity(0.15),
          ),
          boxShadow: _expanded
              ? [
            BoxShadow(
              color: widget.color.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon circle
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.color.withOpacity(0.3)),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.role,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            widget.company,
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.period,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Expand arrow
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            // Expandable bullet list
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: _expanded
                  ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.bullets
                      .map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6, right: 10),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: widget.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skill group with animated progress bars
class _SkillGroup extends StatelessWidget {
  final String category;
  final List<_SkillItem> skills;

  const _SkillGroup({required this.category, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        ...skills.map((s) => _AnimatedSkillBar(skill: s)),
      ],
    );
  }
}

class _SkillItem {
  final String name;
  final double level; // 0.0 to 1.0
  const _SkillItem(this.name, this.level);
}

/// Animated progress bar for a skill
class _AnimatedSkillBar extends StatefulWidget {
  final _SkillItem skill;
  const _AnimatedSkillBar({required this.skill});

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _anim = Tween<double>(begin: 0, end: widget.skill.level).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.skill.name,
                  style: const TextStyle(color: Colors.white60, fontSize: 13)),
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Text(
                  '${(_anim.value * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(3),
            ),
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _anim.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tag chip for concepts
class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6C63FF),
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Project card with hover effect
class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final Color color;
  final IconData icon;
  final String githubUrl;
  final bool isComingSoon;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tags,
    required this.color,
    required this.icon,
    required this.githubUrl,
    required this.isComingSoon,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.color.withOpacity(0.5)
                : widget.color.withOpacity(0.15),
          ),
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: widget.color.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 8),
            )
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: widget.color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (widget.isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Coming Soon',
                      style: TextStyle(color: widget.color, fontSize: 11),
                    ),
                  )
                else
                  Icon(Icons.open_in_new, color: widget.color, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tags
                  .map((t) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
//  TYPEWRITER TEXT ANIMATION WIDGET
// =====================================================
/// Animates text appearing letter by letter
class _TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TypewriterText({required this.text, required this.style});

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText>
    with SingleTickerProviderStateMixin {
  String _displayed = '';
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), _typeNext);
  }

  void _typeNext() {
    if (!mounted) return;
    if (_idx < widget.text.length) {
      setState(() {
        _displayed += widget.text[_idx];
        _idx++;
      });
      Future.delayed(const Duration(milliseconds: 60), _typeNext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayed, style: widget.style);
  }
}

// =====================================================
//  PARTICLE BACKGROUND PAINTER
// =====================================================
/// Draws animated floating dots in the background
class ParticlePainter extends CustomPainter {
  final double progress;

  // Each particle: [x%, y%, size, speed, phase]
  static final List<List<double>> _particles = List.generate(
    50,
        (i) => [
      (i * 137.5) % 100, // x position (%)
      (i * 73.3) % 100,  // y position (%)
      (i % 3) * 1.0 + 1, // size
      (i % 5) * 0.2 + 0.1, // speed
      (i * 0.63) % 1.0,  // phase offset
    ],
  );

  const ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      final x = p[0] / 100 * size.width;
      // Animate y position: particle drifts upward slowly and wraps around
      final yBase = p[1] / 100 * size.height;
      final y = (yBase - progress * size.height * p[3] * 0.3 + size.height) %
          size.height;
      final opacity = (math.sin((progress + p[4]) * math.pi * 2) * 0.5 + 0.5) *
          0.25 + 0.05;

      paint.color = const Color(0xFF6C63FF).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), p[2], paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.progress != progress;
}