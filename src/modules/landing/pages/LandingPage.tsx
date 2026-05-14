import Navbar from '../../../components/landing/Navbar'
import Hero from '../../../components/landing/Hero'
import Features from '../../../components/landing/Features'
import About from '../../../components/landing/About'
import Benefits from '../../../components/landing/Benefits'
import Pricing from '../../../components/landing/Pricing'
import Footer from '../../../components/landing/Footer'

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white dark:bg-slate-950 transition-colors duration-300">
      <Navbar />
      <Hero />
      <Features />
      <About />
      <Benefits />
      <Pricing />
      <Footer />
    </div>
  )
}
