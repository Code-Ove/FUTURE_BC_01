import { useState, useEffect } from 'react';
import {
  Container,
  VStack,
  Heading,
  useToast,
  Input,
  InputGroup,
  InputLeftElement,
  Box,
  Spinner,
  Center,
  Alert,
  AlertIcon,
  AlertTitle,
  AlertDescription,
} from '@chakra-ui/react';
import { FaSearch } from 'react-icons/fa';
import CryptoTable from './components/CryptoTable/CryptoTable';
import Portfolio from './components/Portfolio/Portfolio';
import { fetchCryptoData } from './services/api';

function App() {
  const [cryptoData, setCryptoData] = useState([]);
  const [portfolio, setPortfolio] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const toast = useToast();

  const loadCryptoData = async () => {
    try {
      setIsLoading(true);
      setError(null);
      const data = await fetchCryptoData();
      if (data && Array.isArray(data)) {
        setCryptoData(data);
      } else {
        throw new Error('Invalid data format received');
      }
    } catch (error) {
      console.error('Error fetching data:', error);
      setError('Failed to fetch cryptocurrency data. Please try again later.');
      toast({
        title: 'Error fetching data',
        description: 'Please try again later',
        status: 'error',
        duration: 3000,
        isClosable: true,
      });
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadCryptoData();
    const interval = setInterval(loadCryptoData, 60000);
    return () => clearInterval(interval);
  }, []);

  const handleAddToPortfolio = (coin) => {
    if (!coin) return;
    const existingCoin = portfolio.find((item) => item.id === coin.id);
    if (existingCoin) {
      setPortfolio(portfolio.map((item) =>
        item.id === coin.id
          ? { ...item, amount: item.amount + 1 }
          : item
      ));
    } else {
      setPortfolio([...portfolio, { ...coin, amount: 1 }]);
    }
    toast({
      title: 'Coin added',
      description: `Added ${coin.name} to portfolio`,
      status: 'success',
      duration: 2000,
      isClosable: true,
    });
  };

  const handleRemoveFromPortfolio = (coinId) => {
    if (!coinId) return;
    setPortfolio(portfolio.filter((coin) => coin.id !== coinId));
    toast({
      title: 'Coin removed',
      description: 'Removed from portfolio',
      status: 'info',
      duration: 2000,
      isClosable: true,
    });
  };

  const filteredCryptoData = cryptoData.filter((coin) =>
    coin.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    coin.symbol.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Box bg="gray.50" minH="100vh" py={8}>
      <Container maxW="container.xl">
        <VStack spacing={8} align="stretch">
          <Heading textAlign="center" size="2xl" color="blue.600">
            CoinGear
          </Heading>
          
          <Box maxW="md" mx="auto" w="full">
            <InputGroup size="lg">
              <InputLeftElement pointerEvents="none">
                <FaSearch color="gray.300" />
              </InputLeftElement>
              <Input
                placeholder="Search cryptocurrencies..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                bg="white"
                borderRadius="lg"
                _focus={{
                  borderColor: 'blue.400',
                  boxShadow: '0 0 0 1px var(--chakra-colors-blue-400)',
                }}
              />
            </InputGroup>
          </Box>

          {portfolio && (
            <Portfolio
              portfolio={portfolio}
              onRemoveFromPortfolio={handleRemoveFromPortfolio}
            />
          )}

          {isLoading ? (
            <Center p={8}>
              <Spinner size="xl" color="blue.500" thickness="4px" />
            </Center>
          ) : error ? (
            <Alert status="error" borderRadius="lg">
              <AlertIcon />
              <Box>
                <AlertTitle>Error</AlertTitle>
                <AlertDescription>{error}</AlertDescription>
              </Box>
            </Alert>
          ) : (
            <CryptoTable
              cryptoData={filteredCryptoData}
              onAddToPortfolio={handleAddToPortfolio}
            />
          )}
        </VStack>
      </Container>
    </Box>
  );
}

export default App;
